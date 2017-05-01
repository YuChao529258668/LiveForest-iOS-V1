var path = require('path');

module.exports = {
    entry: path.resolve(__dirname, 'js/main.jsx'),
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js',
    },
    module: {
        loaders: [
            {test: /\.jsx$/, exclude: /node_modules/, loader: 'babel?stage=0'},
            {test: /\.js$/, exclude: /node_modules/, loader: 'babel?stage=0'},

        ],
    },
    externals: {jquery: "jQuery"}
};