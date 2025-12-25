# Database Schema Documentation

## Table of Contents

1. [User Management](#user-management)
2. [Account Management](#account-management)
3. [Transaction System](#transaction-system)
4. [Expense Management](#expense-management)
5. [Savings Management](#savings-management)
6. [Loan Management](#loan-management)
7. [Budget Management](#budget-management)
8. [System Logs](#system-logs)

---

## User Management

### `users`

**Purpose:** Stores user authentication and profile information.

| Field        | Type         | Description                      | Example                 |
| ------------ | ------------ | -------------------------------- | ----------------------- |
| `id`         | int          | Primary key, auto-increment      | `1`                     |
| `name`       | varchar(255) | User's full name                 | `"John Doe"`            |
| `email`      | varchar(255) | Unique email for login           | `"john@example.com"`    |
| `password`   | varchar(255) | Hashed password (bcrypt/argon2)  | `"$2a$10$..."`          |
| `image_url`  | varchar(500) | Profile picture URL              | `"/uploads/avatar.jpg"` |
| `is_active`  | boolean      | Account status (for soft delete) | `true` / `false`        |
| `created_at` | timestamp    | Account creation time            | `2024-01-15 10:30:00`   |
| `updated_at` | timestamp    | Last profile update              | `2024-06-20 14:22:00`   |

**Business Rules:**

- Email must be unique across all users
- Password must be hashed before storage
- Inactive users cannot login but data is preserved

---

## Account Management

### `accounts`

**Purpose:** Central table for all financial accounts (bank, card, wallet, cash, savings).

| Field               | Type          | Description                               | Example                                                  |
| ------------------- | ------------- | ----------------------------------------- | -------------------------------------------------------- |
| `id`                | int           | Primary key                               | `1`                                                      |
| `user_id`           | int           | Owner of the account                      | `1`                                                      |
| `account_type`      | varchar(50)   | Type of account                           | `"bank"` / `"card"` / `"wallet"` / `"cash"` / `"saving"` |
| `name`              | varchar(255)  | User-defined account name                 | `"Main Checking"`, `"Emergency Fund"`                    |
| `balance`           | decimal(15,2) | Current balance                           | `5420.50`                                                |
| `currency`          | varchar(3)    | ISO currency code                         | `"USD"`, `"EUR"`, `"BDT"`                                |
| `is_active`         | boolean       | Active/inactive status                    | `true`                                                   |
| `parent_account_id` | int           | Link to parent account (for sub-accounts) | `NULL` or `5`                                            |
| `created_at`        | timestamp     | Account creation date                     | `2024-01-15 10:30:00`                                    |
| `updated_at`        | timestamp     | Last modification                         | `2024-06-20 14:22:00`                                    |

**Account Types:**

- `bank` - Bank accounts (checking, savings)
- `card` - Credit/debit cards
- `wallet` - Digital wallets (PayPal, Venmo)
- `cash` - Physical cash holdings
- `saving` - Dedicated savings goals

**Business Rules:**

- Balance updates on every transaction
- Parent account allows hierarchical organization (e.g., main account → sub-accounts)

---

### `bank_accounts`

**Purpose:** Stores additional details specific to bank accounts.

| Field            | Type         | Description                       | Example                    |
| ---------------- | ------------ | --------------------------------- | -------------------------- |
| `id`             | int          | Primary key                       | `1`                        |
| `account_id`     | int          | Reference to `accounts` table     | `1`                        |
| `bank_name`      | varchar(255) | Name of the bank                  | `"Chase Bank"`             |
| `account_number` | varchar(50)  | Bank account number               | `"123456789"`              |
| `branch_name`    | varchar(255) | Bank branch location              | `"Downtown Branch"`        |
| `routing_number` | varchar(50)  | Bank routing number (US)          | `"021000021"`              |
| `swift_code`     | varchar(50)  | SWIFT/BIC code for international  | `"CHASUS33"`               |
| `iban`           | varchar(50)  | International bank account number | `"GB29NWBK60161331926819"` |
| `created_at`     | timestamp    | Record creation                   | `2024-01-15 10:30:00`      |
| `updated_at`     | timestamp    | Last update                       | `2024-06-20 14:22:00`      |

---

### `card_accounts`

**Purpose:** Stores credit/debit card information.

| Field               | Type          | Description                     | Example                              |
| ------------------- | ------------- | ------------------------------- | ------------------------------------ |
| `id`                | int           | Primary key                     | `1`                                  |
| `account_id`        | int           | Reference to `accounts`         | `2`                                  |
| `card_name`         | varchar(255)  | Card nickname                   | `"Chase Sapphire"`                   |
| `card_number_last4` | varchar(4)    | Last 4 digits only (security)   | `"4532"`                             |
| `card_type`         | varchar(50)   | Card classification             | `"credit"` / `"debit"` / `"prepaid"` |
| `card_network`      | varchar(50)   | Card payment network            | `"visa"` / `"mastercard"` / `"amex"` |
| `cvv_hash`          | varchar(255)  | Hashed CVV (optional security)  | `"$2a$10$..."`                       |
| `expiry_date`       | date          | Card expiration                 | `2026-12-31`                         |
| `credit_limit`      | decimal(15,2) | Credit limit (for credit cards) | `10000.00`                           |
| `billing_cycle_day` | int           | Day of month for billing        | `15` (15th of month)                 |
| `created_at`        | timestamp     | Record creation                 | `2024-01-15 10:30:00`                |
| `updated_at`        | timestamp     | Last update                     | `2024-06-20 14:22:00`                |

**Security Note:** Never store full card numbers or plain CVV codes.

---

### `wallet_accounts`

**Purpose:** Digital wallet information (PayPal, Venmo, etc.).

| Field               | Type         | Description               | Example                              |
| ------------------- | ------------ | ------------------------- | ------------------------------------ |
| `id`                | int          | Primary key               | `1`                                  |
| `account_id`        | int          | Reference to `accounts`   | `3`                                  |
| `wallet_name`       | varchar(255) | Wallet nickname           | `"PayPal Business"`                  |
| `wallet_provider`   | varchar(100) | Service provider          | `"paypal"` / `"venmo"` / `"cashapp"` |
| `wallet_identifier` | varchar(255) | Email, phone, or username | `"john@example.com"`                 |
| `created_at`        | timestamp    | Record creation           | `2024-01-15 10:30:00`                |
| `updated_at`        | timestamp    | Last update               | `2024-06-20 14:22:00`                |

---

### `cash_accounts`

**Purpose:** Track physical cash holdings.

| Field        | Type         | Description             | Example                            |
| ------------ | ------------ | ----------------------- | ---------------------------------- |
| `id`         | int          | Primary key             | `1`                                |
| `account_id` | int          | Reference to `accounts` | `4`                                |
| `location`   | varchar(255) | Where cash is stored    | `"Wallet"` / `"Safe"` / `"Drawer"` |
| `notes`      | text         | Additional details      | `"Emergency cash only"`            |
| `created_at` | timestamp    | Record creation         | `2024-01-15 10:30:00`              |
| `updated_at` | timestamp    | Last update             | `2024-06-20 14:22:00`              |

---

## Transaction System

### `transactions`

**Purpose:** Universal transaction log - records ALL money movements in the system.

| Field              | Type          | Description                         | Example                                                    |
| ------------------ | ------------- | ----------------------------------- | ---------------------------------------------------------- |
| `id`               | int           | Primary key                         | `1`                                                        |
| `user_id`          | int           | Transaction owner                   | `1`                                                        |
| `account_id`       | int           | Primary account involved            | `1`                                                        |
| `transaction_type` | varchar(50)   | Type of transaction                 | `"income"` / `"expense"` / `"transfer"` / `"loan_payment"` |
| `category`         | varchar(50)   | General category                    | `"expense"` / `"loan"` / `"saving"`                        |
| `amount`           | decimal(15,2) | Transaction amount                  | `150.00`                                                   |
| `balance_after`    | decimal(15,2) | Account balance after transaction   | `5270.50`                                                  |
| `reference_type`   | varchar(50)   | Related entity type                 | `"expenses"` / `"loans_taken"` / `"savings_goals"`         |
| `reference_id`     | int           | ID of related record                | `42`                                                       |
| `from_account_id`  | int           | Source account (for transfers)      | `1`                                                        |
| `to_account_id`    | int           | Destination account (for transfers) | `2`                                                        |
| `transaction_date` | date          | When transaction occurred           | `2024-06-20`                                               |
| `description`      | varchar(500)  | Brief description                   | `"Grocery shopping at Walmart"`                            |
| `notes`            | text          | Detailed notes                      | `"Weekly groceries for family"`                            |
| `is_recurring`     | boolean       | Part of recurring transaction       | `false`                                                    |
| `created_at`       | timestamp     | Record creation                     | `2024-06-20 14:22:00`                                      |

**Transaction Types:**

- `income` - Money coming in
- `expense` - Money going out
- `transfer` - Moving between accounts
- `loan_given` - Lending money to someone
- `loan_taken` - Borrowing money
- `loan_payment` - Paying back a loan
- `saving` - Depositing to savings goal
- `withdrawal` - Taking money out

**Business Logic:**

- Every expense, loan payment, saving, etc. creates a transaction record
- `reference_type` + `reference_id` link to the specific record
- For transfers: both `from_account_id` and `to_account_id` are populated
- `balance_after` maintains audit trail of account balance

---

## Expense Management

### `expense_categories`

**Purpose:** Main categories for organizing expenses.

| Field        | Type         | Description                               | Example                               |
| ------------ | ------------ | ----------------------------------------- | ------------------------------------- |
| `id`         | int          | Primary key                               | `1`                                   |
| `user_id`    | int          | Category owner (NULL for system defaults) | `1` or `NULL`                         |
| `name`       | varchar(100) | Category name                             | `"Food & Dining"`, `"Transportation"` |
| `icon`       | varchar(100) | Icon identifier                           | `"utensils"`, `"car"`                 |
| `color`      | varchar(7)   | Hex color code                            | `"#FF5733"`                           |
| `is_active`  | boolean      | Active status                             | `true`                                |
| `created_at` | timestamp    | Creation time                             | `2024-01-15 10:30:00`                 |

**Common Categories:**

- Food & Dining
- Transportation
- Shopping
- Entertainment
- Bills & Utilities
- Healthcare
- Education
- Travel

---

### `expense_subcategories`

**Purpose:** Detailed subcategories under main expense categories.

| Field                 | Type         | Description      | Example                                    |
| --------------------- | ------------ | ---------------- | ------------------------------------------ |
| `id`                  | int          | Primary key      | `1`                                        |
| `expense_category_id` | int          | Parent category  | `1` (Food & Dining)                        |
| `name`                | varchar(100) | Subcategory name | `"Restaurants"`, `"Groceries"`, `"Coffee"` |
| `icon`                | varchar(100) | Icon identifier  | `"coffee"`                                 |
| `is_active`           | boolean      | Active status    | `true`                                     |
| `created_at`          | timestamp    | Creation time    | `2024-01-15 10:30:00`                      |

---

### `expenses`

**Purpose:** Detailed expense records.

| Field                    | Type          | Description                | Example                                |
| ------------------------ | ------------- | -------------------------- | -------------------------------------- |
| `id`                     | int           | Primary key                | `1`                                    |
| `user_id`                | int           | Expense owner              | `1`                                    |
| `account_id`             | int           | Account used for payment   | `1`                                    |
| `transaction_id`         | int           | Link to transaction record | `42`                                   |
| `expense_category_id`    | int           | Main category              | `1`                                    |
| `expense_subcategory_id` | int           | Subcategory (optional)     | `3`                                    |
| `amount`                 | decimal(15,2) | Expense amount             | `45.50`                                |
| `expense_date`           | date          | When expense occurred      | `2024-06-20`                           |
| `merchant_name`          | varchar(255)  | Store/restaurant name      | `"Starbucks"`                          |
| `location`               | varchar(255)  | Physical location          | `"123 Main St, NYC"`                   |
| `payment_method`         | varchar(50)   | How paid                   | `"credit_card"` / `"cash"` / `"debit"` |
| `notes`                  | text          | Additional details         | `"Team lunch meeting"`                 |
| `is_recurring`           | boolean       | Recurring expense          | `false`                                |
| `created_at`             | timestamp     | Record creation            | `2024-06-20 14:22:00`                  |
| `updated_at`             | timestamp     | Last update                | `2024-06-20 14:22:00`                  |

**Workflow:**

1. Create expense record
2. Automatically create transaction record
3. Update account balance
4. Link expense to transaction via `transaction_id`

---

### `expense_attachments`

**Purpose:** Store receipts and supporting documents.

| Field         | Type         | Description       | Example                                       |
| ------------- | ------------ | ----------------- | --------------------------------------------- |
| `id`          | int          | Primary key       | `1`                                           |
| `expense_id`  | int          | Related expense   | `1`                                           |
| `file_url`    | varchar(500) | File storage path | `"/uploads/receipts/2024/06/receipt_001.jpg"` |
| `file_type`   | varchar(50)  | File format       | `"image/jpeg"` / `"application/pdf"`          |
| `file_size`   | int          | Size in bytes     | `245760` (240 KB)                             |
| `uploaded_at` | timestamp    | Upload time       | `2024-06-20 14:25:00`                         |

---

## Savings Management

### `saving_categories`

**Purpose:** Categorize different savings goals.

| Field        | Type         | Description     | Example                                                  |
| ------------ | ------------ | --------------- | -------------------------------------------------------- |
| `id`         | int          | Primary key     | `1`                                                      |
| `user_id`    | int          | Category owner  | `1` or `NULL`                                            |
| `name`       | varchar(100) | Category name   | `"Emergency Fund"`, `"Vacation"`, `"House Down Payment"` |
| `icon`       | varchar(100) | Icon identifier | `"piggy-bank"`                                           |
| `color`      | varchar(7)   | Hex color       | `"#4CAF50"`                                              |
| `is_active`  | boolean      | Active status   | `true`                                                   |
| `created_at` | timestamp    | Creation time   | `2024-01-15 10:30:00`                                    |

---

### `savings_goals`

**Purpose:** Track progress toward savings targets.

| Field                | Type          | Description               | Example                                    |
| -------------------- | ------------- | ------------------------- | ------------------------------------------ |
| `id`                 | int           | Primary key               | `1`                                        |
| `user_id`            | int           | Goal owner                | `1`                                        |
| `saving_category_id` | int           | Category                  | `1`                                        |
| `source_account_id`  | int           | Where money comes from    | `1` (checking)                             |
| `savings_account_id` | int           | Dedicated savings account | `5` (saving account)                       |
| `goal_name`          | varchar(255)  | Name of goal              | `"Emergency Fund - 6 months"`              |
| `target_amount`      | decimal(15,2) | Goal amount               | `15000.00`                                 |
| `saved_amount`       | decimal(15,2) | Current progress          | `7500.00`                                  |
| `start_date`         | date          | Goal start                | `2024-01-01`                               |
| `target_date`        | date          | Goal deadline             | `2024-12-31`                               |
| `status`             | varchar(50)   | Current status            | `"active"` / `"completed"` / `"cancelled"` |
| `priority`           | int           | Goal priority (1-10)      | `1` (highest)                              |
| `notes`              | text          | Additional details        | `"Need 6 months of expenses saved"`        |
| `created_at`         | timestamp     | Record creation           | `2024-01-01 10:00:00`                      |
| `updated_at`         | timestamp     | Last update               | `2024-06-20 14:22:00`                      |

**Progress Calculation:**

- Progress % = (`saved_amount` / `target_amount`) × 100
- Example: (7500 / 15000) × 100 = 50%

---

## Loan Management

### `loan_taken_categories`

**Purpose:** Categorize loans you've borrowed.

| Field        | Type         | Description     | Example                                           |
| ------------ | ------------ | --------------- | ------------------------------------------------- |
| `id`         | int          | Primary key     | `1`                                               |
| `user_id`    | int          | Category owner  | `1` or `NULL`                                     |
| `name`       | varchar(100) | Category name   | `"Personal Loan"`, `"Student Loan"`, `"Mortgage"` |
| `icon`       | varchar(100) | Icon identifier | `"hand-holding-dollar"`                           |
| `is_active`  | boolean      | Active status   | `true`                                            |
| `created_at` | timestamp    | Creation time   | `2024-01-15 10:30:00`                             |

---

### `loans_taken`

**Purpose:** Track loans you've borrowed from others/institutions.

| Field                    | Type          | Description             | Example                                 |
| ------------------------ | ------------- | ----------------------- | --------------------------------------- |
| `id`                     | int           | Primary key             | `1`                                     |
| `user_id`                | int           | Borrower (you)          | `1`                                     |
| `loan_taken_category_id` | int           | Loan category           | `1`                                     |
| `account_id`             | int           | Account receiving funds | `1`                                     |
| `lender_name`            | varchar(255)  | Who lent the money      | `"Chase Bank"` / `"Uncle John"`         |
| `loan_purpose`           | varchar(255)  | Why borrowed            | `"Home renovation"`                     |
| `loan_date`              | date          | When loan was taken     | `2024-01-15`                            |
| `principal_amount`       | decimal(15,2) | Original loan amount    | `25000.00`                              |
| `interest_rate`          | decimal(5,2)  | Annual interest %       | `5.50` (5.5% APR)                       |
| `duration_months`        | int           | Loan term in months     | `60` (5 years)                          |
| `payment_frequency`      | varchar(50)   | Payment schedule        | `"monthly"` / `"weekly"` / `"biweekly"` |
| `total_paid`             | decimal(15,2) | Amount paid so far      | `5000.00`                               |
| `remaining_balance`      | decimal(15,2) | Still owe               | `20000.00`                              |
| `status`                 | varchar(50)   | Loan status             | `"active"` / `"paid"` / `"defaulted"`   |
| `due_date`               | date          | Final payment date      | `2029-01-15`                            |
| `notes`                  | text          | Additional info         | `"No prepayment penalty"`               |
| `created_at`             | timestamp     | Record creation         | `2024-01-15 10:00:00`                   |
| `updated_at`             | timestamp     | Last update             | `2024-06-20 14:22:00`                   |

---

### `loan_payments`

**Purpose:** Individual payments on loans you've taken.

| Field            | Type          | Description         | Example                     |
| ---------------- | ------------- | ------------------- | --------------------------- |
| `id`             | int           | Primary key         | `1`                         |
| `loan_taken_id`  | int           | Related loan        | `1`                         |
| `transaction_id` | int           | Link to transaction | `50`                        |
| `payment_amount` | decimal(15,2) | Total payment       | `500.00`                    |
| `principal_paid` | decimal(15,2) | Toward principal    | `450.00`                    |
| `interest_paid`  | decimal(15,2) | Toward interest     | `50.00`                     |
| `payment_date`   | date          | When paid           | `2024-06-15`                |
| `payment_method` | varchar(50)   | How paid            | `"bank_transfer"`           |
| `notes`          | text          | Payment notes       | `"Regular monthly payment"` |
| `created_at`     | timestamp     | Record creation     | `2024-06-15 10:00:00`       |

**Business Logic:**

- Each payment updates `loans_taken.total_paid` and `remaining_balance`
- Creates corresponding transaction record
- Updates account balance

---

### `loans_given`

**Purpose:** Track money you've lent to others.

| Field               | Type          | Description             | Example                                 |
| ------------------- | ------------- | ----------------------- | --------------------------------------- |
| `id`                | int           | Primary key             | `1`                                     |
| `user_id`           | int           | Lender (you)            | `1`                                     |
| `account_id`        | int           | Account money came from | `1`                                     |
| `borrower_name`     | varchar(255)  | Who borrowed            | `"Sarah Johnson"`                       |
| `borrower_contact`  | varchar(255)  | Contact info            | `"sarah@example.com"` / `"+1234567890"` |
| `loan_amount`       | decimal(15,2) | Amount lent             | `2000.00`                               |
| `interest_rate`     | decimal(5,2)  | Interest rate (if any)  | `0.00` (interest-free)                  |
| `loan_date`         | date          | When lent               | `2024-03-01`                            |
| `due_date`          | date          | Expected return date    | `2024-12-01`                            |
| `amount_received`   | decimal(15,2) | Paid back so far        | `500.00`                                |
| `remaining_balance` | decimal(15,2) | Still owed              | `1500.00`                               |
| `status`            | varchar(50)   | Loan status             | `"active"` / `"paid"` / `"defaulted"`   |
| `loan_purpose`      | varchar(255)  | Why borrowed            | `"Car repair emergency"`                |
| `notes`             | text          | Additional details      | `"Family member, no rush"`              |
| `created_at`        | timestamp     | Record creation         | `2024-03-01 10:00:00`                   |
| `updated_at`        | timestamp     | Last update             | `2024-06-20 14:22:00`                   |

---

### `loan_repayments`

**Purpose:** Track individual repayments on loans you've given.

| Field                | Type          | Description         | Example                      |
| -------------------- | ------------- | ------------------- | ---------------------------- |
| `id`                 | int           | Primary key         | `1`                          |
| `loan_given_id`      | int           | Related loan        | `1`                          |
| `transaction_id`     | int           | Link to transaction | `55`                         |
| `repayment_amount`   | decimal(15,2) | Total received      | `500.00`                     |
| `principal_received` | decimal(15,2) | Principal portion   | `500.00`                     |
| `interest_received`  | decimal(15,2) | Interest portion    | `0.00`                       |
| `repayment_date`     | date          | When received       | `2024-06-01`                 |
| `payment_method`     | varchar(50)   | How received        | `"cash"` / `"bank_transfer"` |
| `notes`              | text          | Repayment notes     | `"Partial payment received"` |
| `created_at`         | timestamp     | Record creation     | `2024-06-01 10:00:00`        |

---

## Budget Management

### `budgets`

**Purpose:** Set spending limits for categories/time periods.

| Field                 | Type          | Description                  | Example                                   |
| --------------------- | ------------- | ---------------------------- | ----------------------------------------- |
| `id`                  | int           | Primary key                  | `1`                                       |
| `user_id`             | int           | Budget owner                 | `1`                                       |
| `budget_name`         | varchar(255)  | Budget name                  | `"June Food Budget"`                      |
| `budget_type`         | varchar(50)   | Time period type             | `"monthly"` / `"yearly"` / `"custom"`     |
| `amount`              | decimal(15,2) | Budget limit                 | `800.00`                                  |
| `spent_amount`        | decimal(15,2) | Amount spent                 | `450.00`                                  |
| `start_date`          | date          | Budget starts                | `2024-06-01`                              |
| `end_date`            | date          | Budget ends                  | `2024-06-30`                              |
| `expense_category_id` | int           | Specific category (optional) | `1` (Food & Dining)                       |
| `status`              | varchar(50)   | Budget status                | `"active"` / `"exceeded"` / `"completed"` |
| `alert_threshold`     | decimal(5,2)  | Alert at %                   | `80.00` (alert at 80%)                    |
| `notes`               | text          | Budget notes                 | `"Trying to reduce dining out"`           |
| `created_at`          | timestamp     | Record creation              | `2024-06-01 10:00:00`                     |
| `updated_at`          | timestamp     | Last update                  | `2024-06-20 14:22:00`                     |

**Budget Tracking:**

- Remaining = `amount` - `spent_amount` = 350.00
- Used % = (`spent_amount` / `amount`) × 100 = 56.25%
- Alert triggers when Used % ≥ `alert_threshold`

---

## System Logs

### `activity_logs`

**Purpose:** Complete audit trail of all system actions.

| Field         | Type         | Description                | Example                                          |
| ------------- | ------------ | -------------------------- | ------------------------------------------------ |
| `id`          | int          | Primary key                | `1`                                              |
| `user_id`     | int          | Who performed action       | `1`                                              |
| `action`      | varchar(50)  | Type of action             | `"create"` / `"update"` / `"delete"` / `"login"` |
| `entity_type` | varchar(50)  | What was changed           | `"expenses"` / `"accounts"` / `"transactions"`   |
| `entity_id`   | int          | ID of changed record       | `42`                                             |
| `old_values`  | json         | Previous state             | `{"amount": 50.00, "category": "Food"}`          |
| `new_values`  | json         | New state                  | `{"amount": 55.00, "category": "Food"}`          |
| `ip_address`  | varchar(45)  | User's IP address          | `"192.168.1.100"`                                |
| `user_agent`  | varchar(500) | Browser info               | `"Mozilla/5.0..."`                               |
| `description` | text         | Human-readable description | `"Updated expense amount from $50 to $55"`       |
| `created_at`  | timestamp    | When action occurred       | `2024-06-20 14:22:00`                            |

**Common Actions:**

- `create` - New record created
- `update` - Existing record modified
- `delete` - Record deleted
- `login` - User logged in
- `logout` - User logged out
- `export` - Data exported
- `import` - Data imported

---

### `recurring_transactions`

**Purpose:** Templates for automatic recurring transactions.

| Field              | Type          | Description             | Example                                           |
| ------------------ | ------------- | ----------------------- | ------------------------------------------------- |
| `id`               | int           | Primary key             | `1`                                               |
| `user_id`          | int           | Template owner          | `1`                                               |
| `account_id`       | int           | Account to use          | `1`                                               |
| `transaction_type` | varchar(50)   | Type of transaction     | `"expense"` / `"income"`                          |
| `amount`           | decimal(15,2) | Transaction amount      | `150.00`                                          |
| `frequency`        | varchar(50)   | How often               | `"daily"` / `"weekly"` / `"monthly"` / `"yearly"` |
| `start_date`       | date          | When to start           | `2024-01-01`                                      |
| `end_date`         | date          | When to stop (optional) | `2024-12-31` or `NULL`                            |
| `next_occurrence`  | date          | Next scheduled date     | `2024-07-01`                                      |
| `description`      | varchar(500)  | Transaction description | `"Netflix subscription"`                          |
| `category_id`      | int           | Related category        | `5` (Entertainment)                               |
| `is_active`        | boolean       | Currently active        | `true`                                            |
| `created_at`       | timestamp     | Template created        | `2024-01-01 10:00:00`                             |
| `updated_at`       | timestamp     | Last update             | `2024-06-20 14:22:00`                             |

**Frequency Examples:**

- `daily` - Every day
- `weekly` - Every 7 days
- `biweekly` - Every 14 days
- `monthly` - Same day each month
- `yearly` - Annual (e.g., insurance)

**Automation Logic:**

1. System checks `next_occurrence` daily
2. If date matches today and `is_active = true`, create transaction
3. Update `next_occurrence` based on `frequency`

---

## Data Relationships Summary

```
users
  ├── accounts (multiple accounts per user)
  │   ├── bank_accounts (1:1 for bank type)
  │   ├── card_accounts (1:1 for card type)
  │   ├── wallet_accounts (1:1 for wallet type)
  │   ├── cash_accounts (1:1 for cash type)
  │   └── transactions (many per account)
  │
  ├── expenses (many per user)
  │   ├── expense_attachments (many per expense)
  │   └── links to transaction
  │
  ├── savings_goals (many per user)
  │   └── links to saving account
  │
  ├── loans_taken (many per user)
  │   └── loan_payments (many per loan)
  │
  ├── loans_given (many per user)
  │   └── loan_repayments (many per loan)
  │
  ├── budgets (many per user)
  │
  └── activity_logs (audit trail)
```

---

## Key Business Rules

1. **Every financial movement creates a transaction record**

   - Expenses → transaction
   - Loan payments → transaction
   - Savings deposits → transaction
   - Transfers → transaction

2. **Account balance updates are atomic**

   - Balance updates and transaction creation happen together
   - `balance_after` field maintains audit trail

3. **Soft deletes are preferred**

   - Use `is_active = false` instead of hard deletes
   - Preserves historical data and audit trail

4. **All monetary values use decimal(15,2)**

   - Supports up to 999,999,999,999.99
   - Prevents floating-point arithmetic errors

5. **Timestamps track everything**
   - `created_at` - when record was made
   - `updated_at` - when last modified
   - Essential for audit and troubleshooting

---

## Common Use Cases

### Adding an Expense

1. Insert into `expenses` table
2. Create `transactions` record
3. Update `accounts.balance`
4. Update `budgets.spent_amount` if applicable
5. Log in `activity_logs`

### Making a Loan Payment

1. Insert into `loan_payments` table
2. Update `loans_taken.total_paid` and `remaining_balance`
3. Create `transactions` record
4. Update `accounts.balance`
5. Log in `activity_logs`

### Contributing to Savings Goal

1. Create `transactions` record (transfer to savings account)
2. Update `savings_goals.saved_amount`
3. Update both account balances
4. Log in `activity_logs`
5. Check if goal `target_amount` reached → update `status
