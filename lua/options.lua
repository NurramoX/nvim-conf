vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.scrolloff = 4

vim.opt.clipboard = "unnamedplus"
vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.wildignore:append {
  -- Build artifacts and binaries
  "*.o", "*.obj", "*.exe", "*.so", "*.dll", "*.class",
  
  -- Java specific
  "*.jar", "build/**", "target/**", ".gradle/**", "*.war", ".idea/**",
  
  -- Gradle
  ".gradle/**", "gradle-app.setting", ".gradletasknamecache",
  
  -- Go specific
  "bin/", "*.test", "*.out", "vendor/",
  
  -- TypeScript/JavaScript
  "node_modules/**", "npm-debug.log*", "yarn-debug.log*", "yarn-error.log*",
  "*.min.js", "*.min.css", ".npm", ".yarn", "dist/**", "build/**", ".cache/**",
  
  -- React
  ".next/**", "out/**", ".DS_Store", "coverage/**",
  
  -- Git
  ".git/**", ".gitkeep", ".gitignore", ".gitmodules", ".gitattributes",
  
  -- Docker/Podman
  "Dockerfile", "docker-compose.yml", "*.dockerignore",
  
  -- Kubernetes
  "*.yaml", "!kubernetes/**/*.yaml", "!k8s/**/*.yaml", "!helm/**/*.yaml",
  
  -- Misc development files
  ".env*", "*.log", "*.bak", "*.swp", "*.tmp", "*.temp", "tags",
  "*.patch", "*.diff",
  
  -- OS specific files
  ".DS_Store", "Thumbs.db", "ehthumbs.db", "Desktop.ini"
}

