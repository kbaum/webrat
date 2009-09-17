var allLabels = inDocument.getElementsByTagName("label");
var candidateLabels = $A(allLabels).select(function(candidateLabel){
  var regExp = new RegExp('^' + locator + '\\b', 'i');
  var labelText = getText(candidateLabel).strip();
  return (labelText.search(regExp) >= 0);
});
if (candidateLabels.length == 0) {
  return null;
}
candidateLabels = candidateLabels.sortBy(function(s) { return s.length * -1; }); //reverse length sort
var locatedLabel = candidateLabels.first();
var labelFor = locatedLabel.getAttribute('for') || locatedLabel.getAttribute('htmlFor');
if((!labelFor || labelFor == "") && (locatedLabel.hasChildNodes())) {
  var inputTags = locatedLabel.getElementsByTagName("input");
  var textAreaTags = locatedLabel.getElementsByTagName("textarea");
  if(inputTags.length > 0) {
    return inputTags[0];
  } else if(textAreaTags.length > 0) {
    return textAreaTags[0];
  } else {
    return null;
  }
}
return selenium.browserbot.locationStrategies['id'].call(this, labelFor, inDocument, inWindow);
