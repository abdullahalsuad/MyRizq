// Initialize Lucide icons
lucide.createIcons();

// --- STATE MANAGEMENT (Strictly matching DatabaseDocumentation.md) ---
const state = {
  user: { id: 1, name: "Admin User", email: "admin@myrizq.com" },

  // Table: accounts (joined with subtypes for UI presentation)
  accounts: [
    {
      id: 1,
      user_id: 1,
      account_type: "bank",
      name: "Chase Checking",
      balance: 8450.5,
      currency: "USD",
      is_active: true,
      details: {
        bank_name: "Chase",
        account_number: "****1234",
        routing_number: "123456789",
        swift_code: "CHASUS33",
      },
    },
    {
      id: 2,
      user_id: 1,
      account_type: "card",
      name: "Amex Gold",
      balance: -210.0,
      currency: "USD",
      is_active: true,
      details: {
        card_network: "amex",
        card_number_last4: "1005",
        credit_limit: 20000.0,
        billing_cycle_day: 14,
      },
    },
    {
      id: 3,
      user_id: 1,
      account_type: "saving",
      name: "High Yield Savings",
      balance: 15000.0,
      currency: "USD",
      is_active: true,
      details: {}, // Specific savings logic handled in savings_goals usually, but this is the holding account
    },
  ],

  // Table: expense_categories
  categories: [
    { id: 1, name: "Food & Dining", icon: "utensils", color: "#3b82f6" },
    { id: 2, name: "Transportation", icon: "car", color: "#10b981" },
    { id: 3, name: "Housing", icon: "home", color: "#ef4444" },
  ],

  // Table: savings_goals
  savings_goals: [
    {
      id: 1,
      user_id: 1,
      goal_name: "Emergency Fund",
      target_amount: 20000.0,
      saved_amount: 15000.0,
      start_date: "2024-01-01",
      target_date: "2024-12-31",
      status: "active",
      priority: 1,
      notes: "6 months of expenses",
    },
    {
      id: 2,
      user_id: 1,
      goal_name: "Japan Trip",
      target_amount: 5000.0,
      saved_amount: 1200.0,
      start_date: "2024-03-01",
      target_date: "2025-04-01",
      status: "active",
      priority: 5,
      notes: "Spring vacation",
    },
  ],

  // Table: loans_taken
  loans_taken: [
    {
      id: 1,
      user_id: 1,
      lender_name: "Chase Mortgage",
      loan_purpose: "House Purchase",
      principal_amount: 350000.0,
      interest_rate: 6.5,
      duration_months: 360,
      payment_frequency: "monthly",
      total_paid: 12000.0,
      remaining_balance: 338000.0,
      status: "active",
      due_date: "2054-01-01",
    },
  ],

  // Table: loans_given
  loans_given: [
    {
      id: 1,
      user_id: 1,
      borrower_name: "John Smith",
      borrower_contact: "john@email.com",
      loan_purpose: "Car Repair",
      loan_amount: 1000.0,
      interest_rate: 0.0,
      loan_date: "2024-05-10",
      due_date: "2024-10-10",
      amount_received: 200.0,
      remaining_balance: 800.0,
      status: "active",
    },
  ],

  // Table: budgets
  budgets: [
    {
      id: 1,
      user_id: 1,
      budget_name: "Monthly Groceries",
      budget_type: "monthly",
      amount: 600.0,
      spent_amount: 450.0,
      start_date: "2024-06-01",
      end_date: "2024-06-30",
      alert_threshold: 80.0,
      status: "active",
      notes: "Include household items",
    },
  ],

  // Table: transactions (Recent 5)
  transactions: [
    {
      id: 1,
      date: "2024-06-25",
      desc: "Whole Foods",
      type: "expense",
      account: "Chase Checking",
      amount: -124.5,
    },
    {
      id: 2,
      date: "2024-06-15",
      desc: "Paycheck",
      type: "income",
      account: "Chase Checking",
      amount: 4500.0,
    },
  ],
};

// --- DATA FORMATTERS ---
const fmtMoney = (n) =>
  new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" }).format(
    n
  );
const fmtDate = (d) => new Date(d).toLocaleDateString();
const fmtPercent = (n) => `${n}%`;

// --- NAVIGATION ---
function showPage(pageName) {
  document
    .querySelectorAll(".page-content")
    .forEach((p) => p.classList.add("hidden"));
  const pg = document.getElementById(`page-${pageName}`);
  if (pg) {
    pg.classList.remove("hidden");
    renderPage(pageName, pg);
  }

  // Update Nav UI
  document.querySelectorAll(".nav-link").forEach((l) => {
    l.classList.remove("active", "bg-blue-50", "text-blue-600");
    l.classList.add("text-gray-600", "hover:bg-gray-50");
  });
  const active = document.querySelector(`[onclick="showPage('${pageName}')"]`);
  if (active && active.classList.contains("nav-link")) {
    active.classList.add("active", "bg-blue-50", "text-blue-600");
    active.classList.remove("text-gray-600");
  }

  lucide.createIcons();
}

// --- RENDERERS ---

function renderPage(name, container) {
  const renderers = {
    dashboard: renderDashboard,
    accounts: renderAccounts,
    transactions: renderTransactions,
    expenses: renderExpenses,
    savings: renderSavings,
    loans: renderLoans,
    budgets: renderBudgets,
  };
  if (renderers[name]) container.innerHTML = renderers[name]();
  if (name === "expenses" || name === "dashboard") initCharts();
}

function renderDashboard() {
  return `
        <h1 class="text-2xl font-bold mb-6">Dashboard</h1>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            ${_card("Total Balance", fmtMoney(23240.5), "wallet", "blue")}
            ${_card("Monthly Income", fmtMoney(4500.0), "trending-up", "green")}
            ${_card(
              "Monthly Expense",
              fmtMoney(-1850.0),
              "trending-down",
              "red"
            )}
            ${_card("Net Savings", fmtMoney(2650.0), "piggy-bank", "purple")}
        </div>
        <!-- Recent Activity Table -->
        <div class="bg-white rounded-lg shadow border p-6">
            <h2 class="text-lg font-bold mb-4">Recent Transactions</h2>
            ${_transactionTable(state.transactions)}
        </div>
    `;
}

function renderAccounts() {
  return `
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Accounts</h1>
            <button onclick="openModal('addAccount')" class="btn-primary flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded">
                <i data-lucide="plus" class="w-4 h-4"></i> Add Account
            </button>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            ${state.accounts
              .map(
                (acc) => `
                <div class="bg-white p-6 rounded-xl border shadow-sm hover:shadow-md transition">
                    <div class="flex justify-between items-start mb-4">
                        <div class="p-3 rounded-lg ${
                          acc.account_type === "bank"
                            ? "bg-blue-100 text-blue-600"
                            : "bg-purple-100 text-purple-600"
                        }">
                            <i data-lucide="${
                              acc.account_type === "bank"
                                ? "building-2"
                                : acc.account_type === "card"
                                ? "credit-card"
                                : "wallet"
                            }" class="w-6 h-6"></i>
                        </div>
                        <span class="text-xs font-bold uppercase tracking-wider text-gray-500">${
                          acc.account_type
                        }</span>
                    </div>
                    <h3 class="font-bold text-lg">${acc.name}</h3>
                    <p class="text-2xl font-bold mt-1 ${
                      acc.balance < 0 ? "text-red-600" : "text-gray-900"
                    }">${fmtMoney(acc.balance)}</p>
                    
                    <!-- Subtype Specific Details -->
                    <div class="mt-4 pt-4 border-t text-sm text-gray-600 space-y-1">
                        ${
                          acc.details.account_number
                            ? `<p>Acct: ${acc.details.account_number}</p>`
                            : ""
                        }
                        ${
                          acc.details.card_number_last4
                            ? `<p>Card: **** ${acc.details.card_number_last4}</p>`
                            : ""
                        }
                        ${
                          acc.details.billing_cycle_day
                            ? `<p>Bill Day: ${acc.details.billing_cycle_day}th</p>`
                            : ""
                        }
                        <p class="text-xs text-gray-400 mt-2">ID: ${acc.id} • ${
                  acc.currency
                }</p>
                    </div>
                </div>
            `
              )
              .join("")}
        </div>
    `;
}

function renderTransactions() {
  return `
        <h1 class="text-2xl font-bold mb-6">Transactions</h1>
        
        <!-- Filters matches schema types -->
        <div class="bg-white p-4 rounded-lg border mb-6 flex flex-wrap gap-4">
            <select class="border rounded px-3 py-2"><option>All Types</option><option>income</option><option>expense</option><option>transfer</option><option>loan_given</option><option>loan_payment</option></select>
            <input type="date" class="border rounded px-3 py-2">
            <input type="text" placeholder="Search description..." class="border rounded px-3 py-2 flex-grow">
        </div>

        <div class="bg-white rounded-lg border overflow-hidden">
            ${_transactionTable(state.transactions)}
        </div>
    `;
}

function renderExpenses() {
  return `
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Expenses</h1>
            <button onclick="openModal('addExpense')" class="px-4 py-2 bg-red-600 text-white rounded flex items-center gap-2">
                <i data-lucide="minus" class="w-4 h-4"></i> Log Expense
            </button>
        </div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Breakdown -->
            <div class="bg-white p-6 rounded-xl border">
                <h3 class="font-bold mb-4">Category Breakdown</h3>
                ${state.categories
                  .map(
                    (c) => `
                    <div class="mb-4">
                        <div class="flex justify-between text-sm mb-1">
                            <span>${c.name}</span>
                            <span class="font-bold">$450.00</span>
                        </div>
                        <div class="w-full bg-gray-100 rounded-full h-2">
                            <div class="h-2 rounded-full" style="width: 45%; background-color: ${c.color}"></div>
                        </div>
                    </div>
                `
                  )
                  .join("")}
            </div>
            <!-- Mock Chart -->
            <div class="bg-white p-6 rounded-xl border flex items-center justify-center bg-gray-50">
                <p class="text-gray-400">Spending Trends Chart</p>
            </div>
        </div>
    `;
}

function renderSavings() {
  return `
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Savings Goals</h1>
            <button onclick="openModal('addSavings')" class="px-4 py-2 bg-green-600 text-white rounded flex items-center gap-2">
                <i data-lucide="plus" class="w-4 h-4"></i> New Goal
            </button>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            ${state.savings_goals
              .map((g) => {
                const pct = Math.round(
                  (g.saved_amount / g.target_amount) * 100
                );
                return `
                <div class="bg-white p-6 rounded-xl border shadow-sm relative overflow-hidden">
                    <div class="flex justify-between items-start mb-2">
                        <div>
                            <span class="text-xs font-bold text-green-600 uppercase">Priority: ${
                              g.priority
                            }</span>
                            <h3 class="text-xl font-bold">${g.goal_name}</h3>
                        </div>
                        <span class="px-2 py-1 bg-gray-100 text-xs rounded">${
                          g.status
                        }</span>
                    </div>
                    
                    <div class="flex items-end gap-2 mb-4">
                        <span class="text-2xl font-bold text-gray-900">${fmtMoney(
                          g.saved_amount
                        )}</span>
                        <span class="text-sm text-gray-500 mb-1">of ${fmtMoney(
                          g.target_amount
                        )}</span>
                    </div>

                    <div class="w-full bg-gray-100 rounded-full h-3 mb-4">
                        <div class="bg-green-500 h-3 rounded-full transition-all" style="width: ${pct}%"></div>
                    </div>
                    
                    <div class="flex justify-between text-xs text-gray-500 border-t pt-3">
                        <span>Start: ${fmtDate(g.start_date)}</span>
                        <span>Target: ${fmtDate(g.target_date)}</span>
                    </div>
                    ${
                      g.notes
                        ? `<p class="text-xs text-gray-400 mt-2 italic">"${g.notes}"</p>`
                        : ""
                    }
                </div>
                `;
              })
              .join("")}
        </div>
    `;
}

function renderLoans() {
  return `
        <div class="mb-8">
            <h1 class="text-2xl font-bold mb-2">Loans</h1>
            <div class="flex gap-4">
                <button onclick="openModal('addLoanTaken')" class="px-3 py-1 bg-red-100 text-red-700 rounded text-sm font-bold">+ Borrowed (Loan Taken)</button>
                <button onclick="openModal('addLoanGiven')" class="px-3 py-1 bg-green-100 text-green-700 rounded text-sm font-bold">+ Lent (Loan Given)</button>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Loans Taken -->
            <div>
                <h2 class="text-lg font-bold text-red-600 mb-4 border-b pb-2">Loans Taken (Debt)</h2>
                <div class="space-y-4">
                    ${state.loans_taken
                      .map(
                        (l) => `
                        <div class="bg-white border rounded-lg p-4">
                            <div class="flex justify-between mb-1">
                                <span class="font-bold text-gray-900">${
                                  l.lender_name
                                }</span>
                                <span class="font-bold text-red-600">${fmtMoney(
                                  l.remaining_balance
                                )}</span>
                            </div>
                            <p class="text-sm text-gray-600 italic mb-2">${
                              l.loan_purpose
                            }</p>
                            <div class="grid grid-cols-2 gap-2 text-xs text-gray-500 mb-3">
                                <div>Principal: ${fmtMoney(
                                  l.principal_amount
                                )}</div>
                                <div>Rate: ${l.interest_rate}%</div>
                                <div>Term: ${l.duration_months}mo</div>
                                <div>Freq: ${l.payment_frequency}</div>
                            </div>
                            <button class="w-full py-1 text-center border rounded text-xs hover:bg-gray-50">Log Payment</button>
                        </div>
                    `
                      )
                      .join("")}
                </div>
            </div>

            <!-- Loans Given -->
            <div>
                <h2 class="text-lg font-bold text-green-600 mb-4 border-b pb-2">Loans Given (Assets)</h2>
                 <div class="space-y-4">
                    ${state.loans_given
                      .map(
                        (l) => `
                        <div class="bg-white border rounded-lg p-4">
                             <div class="flex justify-between mb-1">
                                <span class="font-bold text-gray-900">${
                                  l.borrower_name
                                }</span>
                                <span class="font-bold text-green-600">${fmtMoney(
                                  l.remaining_balance
                                )}</span>
                            </div>
                            <p class="text-sm text-gray-600 italic mb-2">${
                              l.loan_purpose
                            }</p>
                            <div class="text-xs text-gray-500 mb-3">
                                Contact: ${l.borrower_contact} <br>
                                Due: ${fmtDate(l.due_date)}
                            </div>
                        </div>
                    `
                      )
                      .join("")}
                </div>
            </div>
        </div>
    `;
}

function renderBudgets() {
  return `
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Budgets</h1>
            <button onclick="openModal('addBudget')" class="px-4 py-2 bg-blue-600 text-white rounded flex items-center gap-2">
                <i data-lucide="plus" class="w-4 h-4"></i> Create Budget
            </button>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            ${state.budgets
              .map((b) => {
                const pct = Math.round((b.spent_amount / b.amount) * 100);
                const isAlert = pct >= b.alert_threshold;
                return `
                <div class="bg-white p-6 rounded-xl border ${
                  isAlert ? "border-red-300 ring-1 ring-red-100" : ""
                }">
                    <div class="flex justify-between items-center mb-2">
                        <span class="px-2 py-0.5 rounded bg-gray-100 text-xs uppercase">${
                          b.budget_type
                        }</span>
                        <span class="text-xs text-gray-400">${b.status}</span>
                    </div>
                    <h3 class="font-bold text-lg mb-4">${b.budget_name}</h3>
                    
                    <div class="flex justify-between text-sm mb-1 font-medium">
                        <span class="${
                          isAlert ? "text-red-600" : "text-gray-900"
                        }">${fmtMoney(b.spent_amount)}</span>
                        <span class="text-gray-500">${fmtMoney(b.amount)}</span>
                    </div>
                    
                    <div class="w-full bg-gray-100 rounded-full h-2 mb-4">
                        <div class="${
                          isAlert ? "bg-red-500" : "bg-blue-500"
                        } h-2 rounded-full" style="width: ${pct}%"></div>
                    </div>
                    
                    <div class="text-xs text-gray-400">
                        ${fmtDate(b.start_date)} - ${fmtDate(b.end_date)}
                    </div>
                    ${
                      isAlert
                        ? `<div class="mt-3 text-xs text-red-600 flex items-center gap-1"><i data-lucide="alert-circle" class="w-3 h-3"></i> Threshold ${b.alert_threshold}% exceeded</div>`
                        : ""
                    }
                </div>
                `;
              })
              .join("")}
        </div>
    `;
}

// --- MODAL FORMS with EXACT SCHEMA FIELDS ---

function openModal(type) {
  const el = document.getElementById("modal-content");
  const container = document.getElementById("modal-container");
  container.classList.remove("hidden");
  let html = "";

  if (type === "addAccount") {
    html = `
            <h2 class="text-xl font-bold mb-4">Add Account</h2>
            <form class="space-y-4">
                <select id="accTypeSelect" class="w-full border p-2 rounded" onchange="renderAccountTypeFields(this.value)">
                    <option value="bank">Bank Account</option>
                    <option value="card">Card Account</option>
                    <option value="wallet">Wallet Account</option>
                    <option value="cash">Cash Account</option>
                </select>
                <input type="text" placeholder="Account Name (e.g. Chase Checking)" class="w-full border p-2 rounded">
                <input type="number" placeholder="Initial Balance" class="w-full border p-2 rounded">
                <select class="w-full border p-2 rounded"><option>USD</option><option>EUR</option></select>
                
                <div id="dynamicFields" class="bg-gray-50 p-3 rounded border space-y-3">
                    <!-- Default Bank Fields -->
                    <input type="text" placeholder="Bank Name" class="w-full border p-2 rounded text-sm">
                    <input type="text" placeholder="Account Number" class="w-full border p-2 rounded text-sm">
                    <input type="text" placeholder="Routing Number" class="w-full border p-2 rounded text-sm">
                    <input type="text" placeholder="SWIFT Code" class="w-full border p-2 rounded text-sm">
                    <input type="text" placeholder="IBAN" class="w-full border p-2 rounded text-sm">
                </div>
                <div class="flex justify-end gap-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600">Cancel</button>
                    <button type="button" class="px-4 py-2 bg-blue-600 text-white rounded">Save</button>
                </div>
            </form>
        `;
  } else if (type === "addExpense") {
    html = `
            <h2 class="text-xl font-bold mb-4">Add Expense</h2>
            <form class="space-y-3">
                <div class="grid grid-cols-2 gap-3">
                    <input type="number" placeholder="Amount" class="border p-2 rounded text-lg font-bold">
                    <input type="date" class="border p-2 rounded" value="2024-06-25">
                </div>
                <input type="text" placeholder="Merchant Name" class="w-full border p-2 rounded">
                <select class="w-full border p-2 rounded">
                    ${state.categories
                      .map((c) => `<option value="${c.id}">${c.name}</option>`)
                      .join("")}
                </select>
                <select class="w-full border p-2 rounded text-gray-600">
                    <option value="">Select Subcategory (Optional)</option>
                    <option value="1">Groceries</option>
                    <option value="2">Restaurants</option>
                </select>
                <select class="w-full border p-2 rounded">
                    ${state.accounts
                      .map((a) => `<option value="${a.id}">${a.name}</option>`)
                      .join("")}
                </select>
                
                <!-- Expanded Schema Fields -->
                <input type="text" placeholder="Location (Optional)" class="w-full border p-2 rounded text-sm">
                <select class="w-full border p-2 rounded text-sm">
                    <option value="credit_card">Method: Credit Card</option>
                    <option value="cash">Method: Cash</option>
                    <option value="debit">Method: Debit</option>
                </select>
                <textarea placeholder="Notes" class="w-full border p-2 rounded text-sm h-20"></textarea>
                
                <div class="flex items-center gap-2">
                    <input type="checkbox" id="recurring"> <label for="recurring" class="text-sm">Is Recurring Transaction?</label>
                </div>
                
                 <div>
                    <label class="block text-xs text-gray-500">Attachment (Receipt)</label>
                    <input type="file" class="w-full text-sm">
                </div>

                <div class="flex justify-end gap-2 mt-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600">Cancel</button>
                    <button type="button" class="px-4 py-2 bg-red-600 text-white rounded">Add Expense</button>
                </div>
            </form>
        `;
  } else if (type === "addSavings") {
    html = `
             <h2 class="text-xl font-bold mb-4">New Savings Goal</h2>
             <form class="space-y-3">
                <input type="text" placeholder="Goal Name" class="w-full border p-2 rounded">
                <div class="grid grid-cols-2 gap-3">
                    <input type="number" placeholder="Target Amount" class="border p-2 rounded">
                    <input type="number" placeholder="Initial Saved" class="border p-2 rounded">
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <div><label class="text-xs">Start Date</label><input type="date" class="w-full border p-2 rounded border-gray-300"></div>
                    <div><label class="text-xs">Target Date</label><input type="date" class="w-full border p-2 rounded border-gray-300"></div>
                </div>
                <div class="grid grid-cols-2 gap-3">
                     <select class="border p-2 rounded"><option value="active">Active</option><option value="completed">Completed</option></select>
                     <input type="number" placeholder="Priority (1-10)" class="border p-2 rounded" min="1" max="10">
                </div>
                <textarea placeholder="Notes" class="w-full border p-2 rounded h-20"></textarea>
                <div class="flex justify-end gap-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600">Cancel</button>
                    <button type="button" class="px-4 py-2 bg-green-600 text-white rounded">Save Goal</button>
                </div>
             </form>
        `;
  } else if (type === "addBudget") {
    html = `
            <h2 class="text-xl font-bold mb-4">Create Budget</h2>
            <form class="space-y-3">
                <input type="text" placeholder="Budget Name" class="w-full border p-2 rounded">
                <div class="grid grid-cols-2 gap-3">
                    <select class="border p-2 rounded"><option value="monthly">Monthly</option><option value="yearly">Yearly</option><option value="custom">Custom</option></select>
                    <input type="number" placeholder="Limit Amount" class="border p-2 rounded">
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <div><label class="text-xs">Start Date</label><input type="date" class="w-full border p-2 rounded"></div>
                    <div><label class="text-xs">End Date</label><input type="date" class="w-full border p-2 rounded"></div>
                </div>
                <div class="flex items-center gap-2">
                     <label class="text-sm">Alert Threshold %:</label>
                     <input type="number" value="80" class="border p-2 rounded w-20">
                </div>
                <textarea placeholder="Notes" class="w-full border p-2 rounded h-20"></textarea>
                <div class="flex justify-end gap-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600">Cancel</button>
                    <button type="button" class="px-4 py-2 bg-blue-600 text-white rounded">Set Budget</button>
                </div>
            </form>
        `;
  } else if (type === "addLoanTaken") {
    html = `
            <h2 class="text-xl font-bold mb-4 text-red-600">Add Loan Taken (Liability)</h2>
            <form class="space-y-3">
                <input type="text" placeholder="Lender Name (e.g. Bank/Person)" class="w-full border p-2 rounded">
                <input type="text" placeholder="Loan Purpose" class="w-full border p-2 rounded">
                <div class="grid grid-cols-2 gap-3">
                    <input type="number" placeholder="Principal Amount" class="border p-2 rounded">
                    <input type="number" placeholder="Interest Rate %" class="border p-2 rounded">
                </div>
                <div class="grid grid-cols-2 gap-3">
                    <input type="number" placeholder="Duration (Months)" class="border p-2 rounded">
                    <select class="border p-2 rounded"><option value="monthly">Monthly Payment</option><option value="weekly">Weekly</option></select>
                </div>
                <div><label class="text-xs">Loan Date</label><input type="date" class="w-full border p-2 rounded"></div>
                 <div><label class="text-xs">Due Date</label><input type="date" class="w-full border p-2 rounded"></div>
                <textarea placeholder="Notes / Terms" class="w-full border p-2 rounded h-20"></textarea>
                <div class="flex justify-end gap-2">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600">Cancel</button>
                    <button type="button" class="px-4 py-2 bg-red-600 text-white rounded">Save Loan</button>
                </div>
            </form>
        `;
  }

  el.innerHTML = html;
}

function renderAccountTypeFields(val) {
  const el = document.getElementById("dynamicFields");
  if (val === "bank") {
    el.innerHTML = `
            <input type="text" placeholder="Bank Name" class="w-full border p-2 rounded text-sm">
            <input type="text" placeholder="Account Number" class="w-full border p-2 rounded text-sm">
            <input type="text" placeholder="Routing Number" class="w-full border p-2 rounded text-sm">
            <input type="text" placeholder="SWIFT Code" class="w-full border p-2 rounded text-sm">
        `;
  } else if (val === "card") {
    el.innerHTML = `
             <input type="text" placeholder="Card Nickname" class="w-full border p-2 rounded text-sm">
             <div class="grid grid-cols-2 gap-2">
                 <input type="text" placeholder="Last 4 Digits" class="w-full border p-2 rounded text-sm" maxlength="4">
                 <select class="w-full border p-2 rounded text-sm"><option value="visa">Visa</option><option value="amex">Amex</option><option value="mastercard">Mastercard</option></select>
             </div>
             <input type="number" placeholder="Credit Limit" class="w-full border p-2 rounded text-sm">
             <input type="number" placeholder="Billing Cycle Day (1-31)" class="w-full border p-2 rounded text-sm">
        `;
  } else {
    el.innerHTML = `<input type="text" placeholder="Provider/Location Name" class="w-full border p-2 rounded text-sm">`;
  }
}

function closeModal() {
  document.getElementById("modal-container").classList.add("hidden");
}

// Helpers
function _card(title, value, icon, color) {
  return `
        <div class="bg-white p-6 rounded-xl border shadow-sm">
            <div class="flex items-center gap-3 mb-2">
                <div class="p-2 bg-${color}-100 rounded text-${color}-600"><i data-lucide="${icon}" class="w-5 h-5"></i></div>
                <h3 class="text-sm font-medium text-gray-500">${title}</h3>
            </div>
            <p class="text-2xl font-bold">${value}</p>
        </div>
    `;
}

function _transactionTable(txs) {
  return `
        <table class="w-full text-sm text-left">
            <thead class="bg-gray-50 text-gray-500 uppercase">
                <tr><th class="px-4 py-3">Date</th><th class="px-4 py-3">Description</th><th class="px-4 py-3">Type</th><th class="px-4 py-3 text-right">Amount</th></tr>
            </thead>
            <tbody class="divide-y">
                ${txs
                  .map(
                    (t) => `
                    <tr>
                        <td class="px-4 py-3">${t.date}</td>
                        <td class="px-4 py-3 text-gray-900 font-medium">${
                          t.desc
                        } <div class="text-xs text-gray-400">${
                      t.account
                    }</div></td>
                        <td class="px-4 py-3"><span class="px-2 py-1 bg-gray-100 rounded text-xs">${
                          t.type
                        }</span></td>
                        <td class="px-4 py-3 text-right font-bold ${
                          t.type === "income"
                            ? "text-green-600"
                            : "text-red-600"
                        }">${t.type === "income" ? "+" : ""}${fmtMoney(
                      t.amount
                    )}</td>
                    </tr>
                `
                  )
                  .join("")}
            </tbody>
        </table>
    `;
}

function initCharts() {
  // Chart code hook
}

// Run
document.addEventListener("DOMContentLoaded", () => showPage("dashboard"));
