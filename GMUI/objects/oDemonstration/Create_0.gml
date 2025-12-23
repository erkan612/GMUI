/*Currently noticed problems
* horizontal scrolling is problematic with filling elements(collapsing headers, tree nodes, button width fills etc)
* some style variables are not in use
* the invisible label prefix('##') is not being applied to some elements
*/

gmui_init(fnCascadiaCode);

gmui_apply_theme_earth_bronze();

tabIdx = 0;
treeIdx = undefined;

txD1 = "";

c1 = false;
c2 = false;
c3 = false;

v2 = [ 0, 0 ];
v3 = [ 0, 0, 0 ];
v4 = [ 0, 0, 0, 0 ];

editc4 = gmui_make_color_rgba(0, 0, 255, 255);
buttonc4 = gmui_make_color_rgba(255, 0, 255, 255);

combo_index = 0;

nameData = "";

winsFrame = undefined;

searchText = "";
searchResults = [ ];
// Document 1-10: Health & Wellness
gmui_ls_add_document("doc_001", "Drinking enough water is essential for maintaining good health and energy levels", {
    title: "Hydration Importance",
    tags: ["health", "water", "hydration", "wellness"],
    category: "health",
    priority: "high"
});

gmui_ls_add_document("doc_002", "Regular exercise improves cardiovascular health and mental wellbeing", {
    title: "Exercise Benefits",
    tags: ["fitness", "exercise", "health", "cardio"],
    category: "fitness",
    priority: "high"
});

gmui_ls_add_document("doc_003", "Getting 7-9 hours of sleep each night is crucial for brain function", {
    title: "Sleep Guidelines",
    tags: ["sleep", "rest", "recovery", "brain"],
    category: "health",
    priority: "high"
});

gmui_ls_add_document("doc_004", "Meditation reduces stress and increases mindfulness in daily life", {
    title: "Meditation Practice",
    tags: ["meditation", "mindfulness", "stress", "calm"],
    category: "mental",
    priority: "medium"
});

gmui_ls_add_document("doc_005", "Eating a balanced diet with fruits and vegetables provides essential nutrients", {
    title: "Nutrition Basics",
    tags: ["diet", "nutrition", "food", "health"],
    category: "health",
    priority: "high"
});

gmui_ls_add_document("doc_006", "Walking 10,000 steps daily improves circulation and overall fitness", {
    title: "Daily Walking Goal",
    tags: ["walking", "steps", "activity", "fitness"],
    category: "fitness",
    priority: "medium"
});

gmui_ls_add_document("doc_007", "Stretching regularly prevents muscle stiffness and improves flexibility", {
    title: "Stretching Routine",
    tags: ["stretching", "flexibility", "muscle", "warmup"],
    category: "fitness",
    priority: "medium"
});

gmui_ls_add_document("doc_008", "Annual checkups help detect health issues before they become serious", {
    title: "Health Checkups",
    tags: ["doctor", "checkup", "prevention", "health"],
    category: "health",
    priority: "high"
});

gmui_ls_add_document("doc_009", "Limiting screen time before bed improves sleep quality", {
    title: "Screen Time Management",
    tags: ["screen", "sleep", "digital", "rest"],
    category: "lifestyle",
    priority: "medium"
});

gmui_ls_add_document("doc_010", "Vitamin D from sunlight is important for bone health and mood", {
    title: "Sunlight Benefits",
    tags: ["sunlight", "vitamin D", "mood", "health"],
    category: "health",
    priority: "medium"
});

// Document 11-20: Personal Finance
gmui_ls_add_document("doc_011", "Creating a monthly budget helps track income and expenses effectively", {
    title: "Budget Planning",
    tags: ["budget", "finance", "money", "planning"],
    category: "finance",
    priority: "high"
});

gmui_ls_add_document("doc_012", "Emergency funds should cover 3-6 months of living expenses", {
    title: "Emergency Savings",
    tags: ["savings", "emergency", "security", "money"],
    category: "finance",
    priority: "high"
});

gmui_ls_add_document("doc_013", "Investing early takes advantage of compound interest over time", {
    title: "Early Investing",
    tags: ["investing", "compound", "interest", "growth"],
    category: "finance",
    priority: "medium"
});

gmui_ls_add_document("doc_014", "Paying off high-interest debt quickly saves money in the long run", {
    title: "Debt Management",
    tags: ["debt", "payment", "interest", "finance"],
    category: "finance",
    priority: "high"
});

gmui_ls_add_document("doc_015", "Retirement planning should start as early as possible", {
    title: "Retirement Planning",
    tags: ["retirement", "planning", "future", "savings"],
    category: "finance",
    priority: "medium"
});

gmui_ls_add_document("doc_016", "Credit scores affect loan approvals and interest rates", {
    title: "Credit Score Importance",
    tags: ["credit", "score", "loan", "finance"],
    category: "finance",
    priority: "medium"
});

gmui_ls_add_document("doc_017", "Insurance protects against unexpected financial losses", {
    title: "Insurance Basics",
    tags: ["insurance", "protection", "risk", "finance"],
    category: "finance",
    priority: "medium"
});

gmui_ls_add_document("doc_018", "Tax planning can help maximize deductions and refunds", {
    title: "Tax Strategies",
    tags: ["tax", "planning", "deduction", "finance"],
    category: "finance",
    priority: "medium"
});

gmui_ls_add_document("doc_019", "Avoiding impulse purchases helps maintain financial discipline", {
    title: "Spending Control",
    tags: ["spending", "impulse", "discipline", "money"],
    category: "finance",
    priority: "low"
});

gmui_ls_add_document("doc_020", "Diversifying investments reduces risk in financial portfolios", {
    title: "Investment Diversification",
    tags: ["investment", "diversify", "risk", "portfolio"],
    category: "finance",
    priority: "medium"
});

// Document 21-30: Relationships & Social
gmui_ls_add_document("doc_021", "Active listening improves communication in all relationships", {
    title: "Communication Skills",
    tags: ["listening", "communication", "relationship", "social"],
    category: "social",
    priority: "high"
});

gmui_ls_add_document("doc_022", "Setting boundaries is important for healthy personal relationships", {
    title: "Personal Boundaries",
    tags: ["boundaries", "relationship", "health", "personal"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_023", "Expressing gratitude regularly strengthens connections with others", {
    title: "Gratitude Practice",
    tags: ["gratitude", "thankful", "relationship", "positive"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_024", "Conflict resolution skills help maintain harmony in relationships", {
    title: "Conflict Resolution",
    tags: ["conflict", "resolution", "relationship", "problem"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_025", "Making time for friends and family improves social wellbeing", {
    title: "Social Connections",
    tags: ["friends", "family", "social", "connection"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_026", "Learning to say no protects personal time and energy", {
    title: "Saying No Politely",
    tags: ["boundaries", "time", "energy", "personal"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_027", "Apologizing sincerely repairs trust after misunderstandings", {
    title: "Sincere Apologies",
    tags: ["apology", "trust", "relationship", "repair"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_028", "Supporting others during difficult times builds strong bonds", {
    title: "Supporting Others",
    tags: ["support", "help", "friendship", "care"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_029", "Meeting new people expands social circles and perspectives", {
    title: "Meeting New People",
    tags: ["social", "new", "people", "network"],
    category: "social",
    priority: "low"
});

gmui_ls_add_document("doc_030", "Quality time is more important than quantity in relationships", {
    title: "Quality Time",
    tags: ["time", "quality", "relationship", "attention"],
    category: "social",
    priority: "medium"
});

// Document 31-40: Learning & Productivity
gmui_ls_add_document("doc_031", "The Pomodoro technique improves focus by working in timed intervals", {
    title: "Pomodoro Technique",
    tags: ["productivity", "focus", "time", "work"],
    category: "productivity",
    priority: "medium"
});

gmui_ls_add_document("doc_032", "Taking regular breaks prevents burnout and maintains productivity", {
    title: "Break Importance",
    tags: ["break", "rest", "productivity", "work"],
    category: "productivity",
    priority: "medium"
});

gmui_ls_add_document("doc_033", "Goal setting provides direction and motivation for achievement", {
    title: "Goal Setting",
    tags: ["goal", "planning", "achievement", "motivation"],
    category: "productivity",
    priority: "high"
});

gmui_ls_add_document("doc_034", "Reading daily expands knowledge and improves vocabulary", {
    title: "Daily Reading Habit",
    tags: ["reading", "learning", "knowledge", "habit"],
    category: "learning",
    priority: "medium"
});

gmui_ls_add_document("doc_035", "Journaling helps organize thoughts and track personal growth", {
    title: "Journaling Benefits",
    tags: ["journal", "writing", "reflection", "growth"],
    category: "personal",
    priority: "low"
});

gmui_ls_add_document("doc_036", "Learning a new language improves cognitive abilities and cultural understanding", {
    title: "Language Learning",
    tags: ["language", "learning", "cognitive", "culture"],
    category: "learning",
    priority: "low"
});

gmui_ls_add_document("doc_037", "Time blocking schedules specific tasks for specific times", {
    title: "Time Blocking Method",
    tags: ["time", "schedule", "planning", "productivity"],
    category: "productivity",
    priority: "medium"
});

gmui_ls_add_document("doc_038", "Digital detox periods improve focus and reduce anxiety", {
    title: "Digital Detox",
    tags: ["digital", "detox", "focus", "anxiety"],
    category: "lifestyle",
    priority: "medium"
});

gmui_ls_add_document("doc_039", "Mind mapping organizes ideas visually for better understanding", {
    title: "Mind Mapping",
    tags: ["ideas", "visual", "organization", "planning"],
    category: "productivity",
    priority: "low"
});

gmui_ls_add_document("doc_040", "Continuous learning keeps skills relevant in changing job markets", {
    title: "Lifelong Learning",
    tags: ["learning", "skills", "career", "growth"],
    category: "career",
    priority: "high"
});

// Document 41-50: Lifestyle & Hobbies
gmui_ls_add_document("doc_041", "Gardening reduces stress and provides fresh produce", {
    title: "Gardening Benefits",
    tags: ["gardening", "plants", "stress", "hobby"],
    category: "hobby",
    priority: "low"
});

gmui_ls_add_document("doc_042", "Cooking at home saves money and improves nutrition", {
    title: "Home Cooking",
    tags: ["cooking", "food", "home", "savings"],
    category: "lifestyle",
    priority: "medium"
});

gmui_ls_add_document("doc_043", "Traveling broadens perspectives and creates lasting memories", {
    title: "Travel Experiences",
    tags: ["travel", "experience", "culture", "memory"],
    category: "lifestyle",
    priority: "medium"
});

gmui_ls_add_document("doc_044", "Photography captures moments and develops artistic skills", {
    title: "Photography Hobby",
    tags: ["photography", "art", "memory", "creative"],
    category: "hobby",
    priority: "low"
});

gmui_ls_add_document("doc_045", "Music listening reduces stress and improves mood", {
    title: "Music Therapy",
    tags: ["music", "therapy", "mood", "stress"],
    category: "entertainment",
    priority: "low"
});

gmui_ls_add_document("doc_046", "Volunteering provides purpose and helps communities", {
    title: "Volunteer Work",
    tags: ["volunteer", "community", "purpose", "help"],
    category: "social",
    priority: "medium"
});

gmui_ls_add_document("doc_047", "Decluttering living spaces reduces stress and improves focus", {
    title: "Decluttering Home",
    tags: ["declutter", "organization", "space", "stress"],
    category: "lifestyle",
    priority: "medium"
});

gmui_ls_add_document("doc_048", "Nature walks improve mental health and physical fitness", {
    title: "Nature Walks",
    tags: ["nature", "walk", "mental", "fitness"],
    category: "health",
    priority: "medium"
});

gmui_ls_add_document("doc_049", "Art creation expresses emotions and develops creativity", {
    title: "Art Expression",
    tags: ["art", "creative", "expression", "emotion"],
    category: "hobby",
    priority: "low"
});

gmui_ls_add_document("doc_050", "Morning routines set positive tone for the entire day", {
    title: "Morning Routine",
    tags: ["morning", "routine", "productivity", "day"],
    category: "lifestyle",
    priority: "medium"
});


