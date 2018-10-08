function changeState(el) {
  if (el.readOnly) el.checked = el.readOnly = false;
  else if (!el.checked) el.readOnly = el.indeterminate = true;
}