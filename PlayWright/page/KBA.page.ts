import { BasePage } from "./BasePage.page";

/**
 * Knowledge base for known KBA answers
 */
export const kbaKnowledgeBase: Record<string, string> = {
  "Which of these last names have you used previously?": "Goodman",
  "Which of these addresses are you associated with?": "920 Mill Creek Ave",
  "Which of these cities are you associated with?": "Lyon",
  "Which of these street names are you associated with?": "Pine Dr",
  "Approximately how tall are you?": "6'1",
  "In 2011 you applied for a hunting or fishing license in which of the following states?": "Alaska",
  "Which of these phone numbers have you ever used previously?": "5037849842",
  "In which of the following states have you had a drivers license?": "California",
  "Which of the following is the street name of your most recent previous address?": "Bentley Pl",
  "Which of the following is the street number of your most recent previous address?": "511",
  "In which city does James Smith live or own property?": "Glen Rock",
  "Which of the following people lives or owns property in Dallas?": "Evan Peters",
  "Which state is associated with Rita Hall?": "Pennsylvania",
  "Which of the following people lives or owns property in Alaska?": "Sarah Davis",
  "In which subdivision is your home located on Main Street?": "Coleman Ridge",
  "Which zip code has ever been a part of your address?": "30022",
  "If you have a current auto loan or lease, what was the original amount financed?": "None of the Above",
  "What is the monthly payment of your most recent auto loan or lease if you have one?": "240",
  "In what year was your most recent auto loan or lease established if you have one?": "2016",
  "In what county do you live?": "Banks",
  "Which of the following is a current or previous employer?": "IEC",
  "What is the balance of your mortgage if you currently have one?": "156000",
  "If you currently have a mortgage what was the original amount?": "403000",
  "What is the monthly payment of your mortgage if you currently have one?": "2105",
  "What year was your most recent mortgage established if you currently have one?": "2007",
  "From the following list, select the city in which you lived in 2015.": "Tucker",
  "In what county have you lived previously?": "Dekalb",
  "What state was your social security number issued (this could be the state in which you were born or had your first job)?": "Delaware",
  "If you have a student loan, what is the monthly payment?": "136",
  "How many years have you lived at your current address?": "5",
  "In 2010 what county did you live in?": "Fulton"
};

export class KBAPage extends BasePage {

  private readonly MAX_RETRY_COUNT = 5;

  /**
   * Main KBA entry
   */
  async KBApage(coapp?: boolean) {
    const continueBtn = this.page.getByRole("button", { name: "Continue" });
    let kbaResponseData: any = null;

    for (let attempt = 1; attempt <= this.MAX_RETRY_COUNT; attempt++) {
      console.log(`KBA API chain attempt ${attempt}/${this.MAX_RETRY_COUNT}`);

      try {
        const [response1] = await Promise.all([
          this.page.waitForResponse("**/process-payload?**", { timeout: 45000 }),
          continueBtn.click()
        ]);

        const data1 = await response1.json();

        if (data1?.meta?.success && data1?.meta?.code === 200) {
          const response2 = await this.page.waitForResponse("**/fraud-verification-status?**", { timeout: 45000 });
          const data2 = await response2.json();

          if (response2.status() === 200) {
            kbaResponseData = data2;
            console.log("KBA API response received");
            break;
          }
        }
      } catch (err) {
        console.warn(`Attempt ${attempt} failed`, err);
      }

      await this.page.waitForTimeout(40000);
    }

    if (!kbaResponseData) {
      throw new Error("KBA API chain failed after maximum retries");
    }

    await this.handleKbaQuestions(kbaResponseData);

    if (coapp) {
      await this.page.waitForSelector('text="Thank You!"');
    }
  }

  /**
   * Normalize text for reliable matching
   */
  private normalize(text: string): string {
    return text
      .toLowerCase()
      .replace(/"/g, "")            // inches symbol
      .replace(/\$/g, "")           // currency
      .replace(/,/g, "")
      .replace(/\s+/g, "")
      .trim();
  }

  /**
   * Answer KBA questions
   */
  private async handleKbaQuestions(data: any): Promise<void> {

    if (data?.result?.flag !== "KBA_REQUIRED") {
      console.warn(`KBA not required. Flag: ${data?.result?.flag}`);
      return;
    }

    const questions = data.result?.KbaQuestions?.Questions || [];

    for (let index = 0; index < questions.length; index++) {
      const question = questions[index];
      const expectedAnswer = kbaKnowledgeBase[question.QuestionText];

      if (!expectedAnswer) {
        console.warn(`No KB answer for question: ${question.QuestionText}`);
        continue;
      }

      const normalizedExpected = this.normalize(expectedAnswer);

      const matchedOption = question.Choices.find((choice: any) =>
        this.normalize(choice.ChoiceText) === normalizedExpected
      );

      if (!matchedOption) {
        console.error(
          `Answer not found for question: ${question.QuestionText}. Expected: ${expectedAnswer}`
        );
        continue;
      }

      console.log(
        `Answering Q${index}: "${question.QuestionText}" -> "${matchedOption.ChoiceText}"`
      );

      await this.page
        .locator(`#question-${index}-option-${matchedOption.Id}`)
        .click();
    }

    const submitBtn = this.page.getByRole("button", { name: "Submit" });
    await submitBtn.waitFor({ state: "visible" });
    await submitBtn.click();

    console.log("KBA submitted successfully");
  }
}
