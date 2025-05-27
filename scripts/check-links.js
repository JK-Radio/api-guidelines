/**
 * Script to check links in markdown files
 * Works in both Windows and Linux environments
 */
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');
const { exec } = require('child_process');
const execAsync = promisify(exec);
const markdownLinkCheck = require('markdown-link-check');

// Configuration for markdown-link-check
let config;
try {
  const configPath = path.join(__dirname, '..', '.markdown-link-check.json');
  config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  console.log('Loaded configuration from .markdown-link-check.json');
} catch (error) {
  console.log('No configuration file found, using default configuration');
  config = {
    ignorePatterns: [
      { pattern: '^https://jkradio.internal/' }
    ],
    replacementPatterns: [],
    timeout: '20s',
    retryOn429: true,
    retryCount: 3
  };
}

// Function to find all markdown files
async function findMarkdownFiles() {
  let files = [];
  
  try {
    // Find all markdown files in the repository
    const rootDir = path.join(__dirname, '..');
    
    // Use glob pattern to find markdown files
    const glob = require('glob');
    files = glob.sync('**/*.md', { 
      cwd: rootDir,
      ignore: ['node_modules/**', '**/node_modules/**'] 
    }).map(file => path.join(rootDir, file));
    
    console.log(`Found ${files.length} markdown files`);
  } catch (error) {
    console.error('Error finding markdown files:', error);
    process.exit(1);
  }
  
  return files;
}

// Function to check links in a markdown file
async function checkLinks(file) {
  return new Promise((resolve, reject) => {
    console.log(`\nChecking links in file: ${path.relative(process.cwd(), file)}`);
    
    const markdown = fs.readFileSync(file, 'utf8');
    
    markdownLinkCheck(markdown, {
      baseUrl: `file://${path.dirname(file)}`,
      ...config
    }, (err, results) => {
      if (err) {
        console.error(`Error checking links in ${file}:`, err);
        reject(err);
        return;
      }
      
      const brokenLinks = results.filter(result => result.status === 'dead');
      
      if (brokenLinks.length > 0) {
        console.error(`\n❌ Found ${brokenLinks.length} broken links in ${path.relative(process.cwd(), file)}:`);
        brokenLinks.forEach(link => {
          console.error(`   - ${link.link}: ${link.statusCode || 'Error'}`);
        });
        reject(new Error(`${brokenLinks.length} broken links found in ${path.relative(process.cwd(), file)}`));
      } else {
        console.log(`✅ All links in ${path.relative(process.cwd(), file)} are valid`);
        resolve();
      }
    });
  });
}

// Main function
async function main() {
  try {
    const files = await findMarkdownFiles();
    let hasErrors = false;
    
    for (const file of files) {
      try {
        await checkLinks(file);
      } catch (error) {
        hasErrors = true;
        // Continue with other files even if one fails
      }
    }
    
    if (hasErrors) {
      console.error('\n❌ Some links are broken. Please fix them before committing.');
      process.exit(1);
    } else {
      console.log('\n✅ All links in all markdown files are valid!');
    }
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

// Run the main function
main().catch(error => {
  console.error('Unhandled error:', error);
  process.exit(1);
});
