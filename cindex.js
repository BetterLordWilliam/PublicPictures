const SITE_BASE_URL = "https://github.com/BetterLordWilliam/PublicPictures/tree/main";

(async function() {
    console.log("Client-side javascript is running...");
    const res = await fetch(`${SITE_BASE_URL}/content`);
    console.log(`${JSON.stringify(res)}`);
})();
