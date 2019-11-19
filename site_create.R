#script to create site
library(blogdown)
install_hugo()

#intialize the site
new_site(
  dir = 'website_source',
  theme = 'lgaida/mediumish-gohugo-theme',
  format = 'toml'
)