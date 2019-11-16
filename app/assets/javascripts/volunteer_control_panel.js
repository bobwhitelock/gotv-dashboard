const debouncedUpdaters = {};

function increaseVolunteersControl(formIdentifier, updateUrl) {
  volunteersControl(formIdentifier, updateUrl, function(value) {
    return value + 1;
  });
}

function decreaseVolunteersControl(formIdentifier, updateUrl) {
  volunteersControl(formIdentifier, updateUrl, function(value) {
    return value - 1;
  });
}

function volunteersControl(formIdentifier, updateUrl, updateCallback) {
  const valueElement = elementFor(formIdentifier, 'value');
  const newValue = updateCallback(+valueElement.innerHTML);

  if (newValue >= 0) {
    valueElement.innerHTML = newValue;

    let updateServer = debouncedUpdaters[formIdentifier];
    if (!updateServer) {
      updateServer = _.debounce(function() {
        const savingElement = elementFor(formIdentifier, 'saving');
        savingElement.classList.remove('is-invisible');

        const data = {count: valueElement.innerHTML};
        function onSuccess() {
          savingElement.classList.add('is-invisible')
        }

        // XXX Add better error handling
        $.post(updateUrl, data, onSuccess);
      }, 500);

      debouncedUpdaters[formIdentifier] = updateServer;
    }

    updateServer();
  }
}

function elementFor(formIdentifier, type) {
  const controlValueId = `${formIdentifier}-${type}`;
  return document.getElementById(controlValueId);
}
