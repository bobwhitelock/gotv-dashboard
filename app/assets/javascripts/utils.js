function checkAllWithName(name) {
  updateAllCheckboxes({name, value: true});
}

function uncheckAllWithName(name) {
  updateAllCheckboxes({name, value: false});
}

function updateAllCheckboxes({name, value}) {
  document
    .querySelectorAll(`[name='${name}']`)
    .forEach((element) => (element.checked = value));
}
