export { highlight };

function highlight(content, query) {
  var search = new RegExp(query, 'ig');
  return content
    .toString()
    .replace(search, match => `<span class="highlight">${match}</span>`);
}
