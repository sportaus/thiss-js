const merge = require('webpack-merge');
const common = require('./webpack.common.js');
const webpack = require('webpack');

module.exports = merge(common, {
  mode: 'production',
  plugins: [
    new webpack.EnvironmentPlugin({
      BASE_URL: 'http://localhost:8887/',
      COMPONENT_URL: 'http://localhost:8887/cta/',
      MDQ_URL: 'http://localhost:8080/entities/',
      PERSISTENCE_URL: 'http://localhost:8887/ps/',
      SEARCH_URL: 'http://localhost:8080/entities/',
      STORAGE_DOMAIN: 'localhost:8887',
      LOGLEVEL: 'warn',
      DEFAULT_CONTEXT: 'thiss.io'
    })
  ]
});
