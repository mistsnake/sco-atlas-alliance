const puppeteer = require('puppeteer');

(async () => {
  // Launch a headless browser
  const browser = await puppeteer.launch();

  // Open a new page
  const page = await browser.newPage();

  // Navigate to the desired website
  await page.goto('https://github.com/mistsnake/sco-atlas-alliance');

  // Set the dimensions of the PDF
  await page.pdf({
    path: 'testing_puppeteer.pdf', // PDF name
    format: 'A4', // Page Size
    printBackground: true // print background colors and images
  });

  // Close the browser
  await browser.close();
})();

// To run, use Node.js
// node testing.js
