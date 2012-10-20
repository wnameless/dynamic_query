$('.query_op').live('change', function() {
  var _ref, _ref1;
  if ((_ref = $(this).val()) === 'IS NULL' || _ref === 'IS NOT NULL') {
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value1').val('');
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value2').val('');
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value1').hide();
    return $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value2').hide();
  } else if ((_ref1 = $(this).val()) === 'BETWEEN' || _ref1 === 'NOT BETWEEN') {
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value1').show();
    return $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value2').show();
  } else {
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value1').show();
    $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value2').val('');
    return $('#' + $(this).attr('id').split(/_/).slice(0, -1).join('_') + '_value2').hide();
  }
});
