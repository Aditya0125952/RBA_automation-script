import { listeners } from "process";
import { BasePage } from "./BasePage.page";

export class OfferPage extends BasePage{
    async offerpagefunction(){
        let flag= false;
        const loanStatus = async(res :any)=>{
            console.log("API hit:", res.url());
            if (!res.url().includes('posLoanOffers')) return;
            try{
                const response=await res.json();
                if( response.loanStatus === "OFFERS_RECEIVED"){
                    console.log("got offer or in pending status");
                    flag = true;
                    this.page.off("response", loanStatus);
                    return
                }
            }catch(e){
                console.log("got the below error : ",e);
            }
        };
        this.page.on("response",loanStatus);
        while(!flag){
            await this.page.waitForTimeout(500);
        }
    }
}