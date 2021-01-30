const {environment} = require('@rails/webpacker')
var webpack = require('webpack');

environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'admin-lte/plugins/jquery/jquery.min',
        jQuery: 'admin-lte/plugins/jquery/jquery.min',
    })
)
// エイリアスの設定をする
environment.toWebpackConfig().merge({
    resolve: {
        alias: {
            'jquery': 'admin-lte/plugins/jquery/jquery.min'
        }
    }
});

module.exports = environment
