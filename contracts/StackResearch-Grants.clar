;; ResearchBoost: Collaborative Research Funding Smart Contract

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-FUNDS (err u101))
(define-constant ERR-PROJECT-NOT-FOUND (err u103))
(define-constant ERR-INVALID-INPUT (err u104))

;; Project status enum
(define-constant PROJECT-STATUS-PROPOSED u0)
(define-constant PROJECT-STATUS-FUNDED u1)
(define-constant PROJECT-STATUS-COMPLETED u2)

;; Data structures
(define-map projects
    { project-id: uint }
    {
        researcher: principal,
        title: (string-utf8 100),
        description: (string-utf8 500),
        total-funding-required: uint,
        current-funding: uint,
        status: uint
    }
)

;; Track project IDs
(define-data-var next-project-id uint u1)

;; Function to propose a new research project
(define-public (propose-project 
    (title (string-utf8 100))
    (description (string-utf8 500))
    (total-funding-required uint))
    (begin
        ;; Validate inputs
        (asserts! (>= (len title) u1) ERR-INVALID-INPUT)
        (asserts! (>= (len description) u1) ERR-INVALID-INPUT)
        (asserts! (> total-funding-required u0) ERR-INVALID-INPUT)

        ;; Generate project ID
        (let ((project-id (var-get next-project-id)))
            ;; Create project mapping
            (map-set projects 
                { project-id: project-id }
                {
                    researcher: tx-sender,
                    title: title,
                    description: description,
                    total-funding-required: total-funding-required,
                    current-funding: u0,
                    status: PROJECT-STATUS-PROPOSED
                }
            )

            ;; Increment project ID
            (var-set next-project-id (+ project-id u1))

            ;; Return project ID
            (ok project-id)
        )
    )
)

;; Function to fund a project
(define-public (fund-project (project-id uint) (funding-amount uint))
    (begin
        ;; Validate inputs
        (asserts! (> funding-amount u0) ERR-INVALID-INPUT)

        ;; Retrieve project
        (let ((project (unwrap! (map-get? projects { project-id: project-id }) ERR-PROJECT-NOT-FOUND)))
            ;; Ensure project is in proposed status
            (asserts! (is-eq (get status project) PROJECT-STATUS-PROPOSED) ERR-UNAUTHORIZED)

            ;; Check if funding would exceed total required
            (asserts! 
                (<= (+ (get current-funding project) funding-amount) (get total-funding-required project)) 
                ERR-INSUFFICIENT-FUNDS
            )

            ;; Transfer funds
            (try! (stx-transfer? funding-amount tx-sender (as-contract tx-sender)))

            ;; Update project funding
            (map-set projects 
                { project-id: project-id }
                (merge project {
                    current-funding: (+ (get current-funding project) funding-amount),
                    status: (if (is-eq (+ (get current-funding project) funding-amount) (get total-funding-required project)) 
                                PROJECT-STATUS-FUNDED 
                                (get status project))
                })
            )

            (ok true)
        )
    )
)

;; Function to complete a project
(define-public (complete-project (project-id uint))
    (begin
        ;; Retrieve project
        (let ((project (unwrap! (map-get? projects { project-id: project-id }) ERR-PROJECT-NOT-FOUND)))
            ;; Ensure sender is the researcher
            (asserts! (is-eq tx-sender (get researcher project)) ERR-UNAUTHORIZED)

            ;; Ensure project is funded
            (asserts! (is-eq (get status project) PROJECT-STATUS-FUNDED) ERR-UNAUTHORIZED)

            ;; Update project status to completed
            (map-set projects 
                { project-id: project-id }
                (merge project { status: PROJECT-STATUS-COMPLETED })
            )

            (ok true)
        )
    )
)