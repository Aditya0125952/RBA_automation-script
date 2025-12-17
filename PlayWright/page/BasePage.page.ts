import { Page } from "@playwright/test";

export class BasePage {
    private static _page: Page;

    constructor(page?: Page) {
        if (page) {
            BasePage._page = page;
        }
    }

    /** Access current active page */
    protected get page(): Page {
        return BasePage._page;
    }

    /** Switch Playwright to a new active page (new tab etc) */
    public static updatePage(newPage: Page) {
        BasePage._page = newPage;
    }
}
