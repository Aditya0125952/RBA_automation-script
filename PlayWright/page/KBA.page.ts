import { BasePage } from "./BasePage.page";
import { Locator } from "@playwright/test";

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
  "If you have a student loan, what is the monthly payment?": "$136",
  "How many years have you lived at your current address?": "5",
  "In 2010 what county did you live in?": "Fulton"
};

export class KBAPage extends BasePage {
    
    private readonly MAX_RETRY_COUNT = 5;

    async KBApage(coapp?:Boolean) {
        const continueBtn = this.page.getByRole('button', { name: 'Continue' });
        let kbaResponseData = null;
        
        // --- 1. Controlled Retry Loop for API Chain ---
        for (let attempt = 1; attempt <= this.MAX_RETRY_COUNT; attempt++) {
            console.log(`API Chain Check (Attempt ${attempt}/${this.MAX_RETRY_COUNT})...`);

            try {
                // Phase 1: Wait for the CRITICAL 'process-payload' response AND the click.
                const [response1] = await Promise.all([
                    this.page.waitForResponse('**/process-payload?**', { timeout: 45000 }),
                    continueBtn.click(),
                ]);

                const data1 = await response1.json();

                if (data1.meta?.success && data1.meta?.code === 200) {
                    // Phase 2: Wait for the SECOND, subsequent API call (fraud-verification-status)
                    const response2 = await this.page.waitForResponse('**/fraud-verification-status?**');
                    const data2 = await response2.json();
                    
                    // Validate the second API response
                    if (response2.status() === 200) {
                        console.log("API 2 (KBA Status) successful. Data received.");
                        kbaResponseData = data2; // Store the KBA data
                        break; // Exit the loop on full success
                    } else {
                        throw new Error(`API 2 failed with status: ${response2.status()}`);
                    }
                } else {
                    console.warn(`API 1 failed (Attempt ${attempt}): ${data1.meta?.message}.`);
                }
            } catch (error) {
                console.warn(`Chain failed on attempt ${attempt}. Error: ${error}. Retrying...`);
            }
            
            await this.page.waitForTimeout(40000); // Wait before next click
        }
        
        if (!kbaResponseData) {
            throw new Error(`API Chain failed after ${this.MAX_RETRY_COUNT} attempts. Cannot proceed.`);
        }
        await this.handleKbaQuestions(kbaResponseData); 
        
        if (coapp){
            await this.page.waitForSelector('text="Thank You!"');
        }
    }
    
    // --- Helper for KBA Question Handling ---
    private async handleKbaQuestions(data: any): Promise<void> {
        
        if (data.result?.flag !== "KBA_REQUIRED") {
             console.warn(`KBA not required. Flag was: ${data.result?.flag}. Skipping answers.`);
             return;
        }

        const questions = data.result.KbaQuestions?.Questions || [];
        let questno = 0;

        for (const q of questions) {
            const expectedAnswer = kbaKnowledgeBase[q.QuestionText];
            
            if (!expectedAnswer) {
                console.warn(`No known answer for question: "${q.QuestionText}". Skipping.`);
                continue;
            }

            const answerOption = q.Choices.find(option => option.ChoiceText === expectedAnswer);
            
            if (!answerOption) {
                 console.error(`ERROR: Correct answer "${expectedAnswer}" not found in options for question: ${q.QuestionText}`);
                 continue;
            }

            console.log(`Question ${questno}: "${q.QuestionText}". Selecting Answer ID: ${answerOption.Id}`);
            
            const group = `que${questno}`;
            await this.page.locator(`#question-${questno}-option-${answerOption.Id}`).click(); 
            
            questno++;
        }
        
      
        const submitKbaBtn = this.page.getByRole('button', { name: 'Submit' }); 
        await submitKbaBtn.waitFor({state : 'visible'});
        
        // Ensure the button is enabled before clicking
        await submitKbaBtn.click();
        
        console.log("KBA answers submitted successfully.");
    }
}