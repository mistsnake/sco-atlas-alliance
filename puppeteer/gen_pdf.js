const puppeteer = require('puppeteer'); // Import puppeteer
const fs = require('fs'); // Import node.js file system (fs) module
const path = require('path'); // Import node.js path module

async function generatePDF(tableData, paragraphText, imagePath) {
  // Launch a headless browser
  const browser = await puppeteer.launch();

  // Open a new page
  const page = await browser.newPage();

  // Generate HTML content for the PDF
  const htmlContent = `
    <html>
    <head>
      <style>
        table {
          width: 100%;
          border-collapse: collapse;
        }
        th, td {
          border: 1px solid black;
          padding: 8px;
          text-align: left;
        }
      </style>
    </head>
    <body>
      <h1>Table</h1>
      <table>
        <thead>
          <tr>
            <th>Column 1</th>
            <th>Column 2</th>
            <th>Column 3</th>
          </tr>
        </thead>
        <tbody>
          ${tableData.map(row => `<tr>${row.map(cell => `<td>${cell}</td>`).join('')}</tr>`).join('')}
        </tbody>
      </table>
      <h1>Paragraph</h1>
      <p>${paragraphText}</p>
      <h1>Image</h1>
      <img src="${imagePath}" alt="Image" style="max-width: 100%;">
    </body>
    </html>
  `;

  // Set HTML content and wait for page to load
  await page.setContent(htmlContent, { waitUntil: 'domcontentloaded' });

  // Set the dimensions of the PDF
  const pdfPath = 'output.pdf';
  await page.pdf({
    path: pdfPath,
    format: 'A4',
    printBackground: true
  });

  // Close the browser
  await browser.close();

  // For debugging: print message with the path where the PDF is saved
  console.log(`PDF generated successfully at: ${pdfPath}`);
}

// Example inputs
// Can be ajusted depending on what type of input to expect
const tableData = [
  ['A1', 'B1', 'C1'],
  ['A2', 'B2', 'C2'],
  ['A3', 'B3', 'C3']
];
const paragraphText = 'This is a sample paragraph text.';
const imagePath = path.join(__dirname, 'sample_image.png'); // Get absolute path of the image file

generatePDF(tableData, paragraphText, imagePath);

// run with node gen_pdf.js