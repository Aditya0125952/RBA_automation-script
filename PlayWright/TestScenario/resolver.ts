function resolveUserKey(
  role: "applicant" | "coApplicant",
  scenario: TestCaseControl,
  users: Record<string, ApplicantData>
): string {

  const lender = scenario.lender?.name;
  const isSpecialLender =
    lender === "GoodLeap" || lender === "Upgrade";

  const explicitKey =
    role === "applicant"
      ? scenario.Applicant_Test_Data
      : scenario.Co_Applicant_Test_Data;

  // 1️⃣ Explicit key always wins
  if (explicitKey?.trim()) {
    return explicitKey.trim();
  }

  // 2️⃣ Special lender → random special user
  if (isSpecialLender) {
    const pool = Object.entries(users)
      .filter(([_, u]) =>
        u.supportedLenders?.includes(lender)
      );

    if (pool.length === 0) {
      throw new Error(`No ${role} users for lender ${lender}`);
    }

    const [key] =
      pool[Math.floor(Math.random() * pool.length)];

    console.log(
      `Auto-selected ${role} '${key}' for ${lender}`
    );

    return key;
  }

  // 3️⃣ Default fallback users
  return role === "applicant"
    ? "Ana_Villar"
    : "Morghan_Blake";
}
