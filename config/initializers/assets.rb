# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# http://guides.rubyonrails.org/asset_pipeline.html
# http://tech-kazuhisa.hatenablog.com/entry/20110918/1316351709
Rails.application.config.assets.precompile += %w( reports.js )
Rails.application.config.assets.precompile += %w( progresses.js )
Rails.application.config.assets.precompile += %w( tagcloud.js )
Rails.application.config.assets.precompile += %w( slide.js )
Rails.application.config.assets.precompile += %w( templates.js )
Rails.application.config.assets.precompile += %w( favarites.js )
