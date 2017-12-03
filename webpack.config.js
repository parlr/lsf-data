const path = require("path");
const webpack = require("webpack");
const UglifyJSPlugin = require("uglifyjs-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: "./src/main.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "build.js"
  },
  plugins: [
    new webpack.IgnorePlugin(/^electron$/),
    new ExtractTextPlugin("lsf.min.css")
  ],
  module: {
    rules: [
      { test: /\.vue$/, loader: "vue-loader" },
      { test: /\.(eot|ttf|woff|woff2)$/, loader: "url-loader" },
      { test: /\.js$/, loader: "babel-loader" },
      { test: /\.(svg|ico)$/, loader: "file-loader" },
      { test: /manifest\.json$/, loader: "file-loader", options: {name: '[name].[ext]'} },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "sass-loader"],
        })
      }
    ]
  },
  resolve: { alias: { vue$: "vue/dist/vue.runtime.min.js" } },
  devServer: { overlay: true }
};

if (process.env.NODE_ENV === "production") {
  module.exports.plugins = (module.exports.plugins || []).concat([
    new webpack.DefinePlugin({ "process.env": { NODE_ENV: '"production"' } }),
    new UglifyJSPlugin({ uglifyOptions: { beautify: false, ecma: 6 } }),
    new HtmlWebpackPlugin({ template: path.resolve(__dirname, "index.html") }),
    new CopyWebpackPlugin([
      { from: "./src/assets/manifest.json" },
      { from: "./src/assets/images/**/icon-*", to: "./images", flatten: true }
    ])
  ]);
}
