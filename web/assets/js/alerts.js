(function($) {
  showSwal = function(type, customOptions) {
    'use strict';
    var options = {
      button: {
        text: "OK",
        value: true,
        visible: true,
        className: "btn btn-primary"
      }
    };

    if (type === 'basic') {
      options.text = 'Any fool can use a computer';
      swal(options);

    } else if (type === 'title-and-text') {
      options.title = 'Read the alert!';
      options.text = 'Click OK to close this alert';
      swal(options);

    } else if (type === 'success-message') {
      options.title = customOptions && customOptions.title ? customOptions.title : 'Congratulations!';
      options.text = customOptions && customOptions.text ? customOptions.text : 'You entered the correct answer';
      options.icon = 'success';
      options.button.text = customOptions && customOptions.buttonText ? customOptions.buttonText : "Continue";
      swal(options);

    } else if (type === 'auto-close') {
      swal({
        title: 'Auto close alert!',
        text: 'I will close in 2 seconds.',
        timer: 2000,
        button: false
      }).then(
        function() {},
        // handling the promise rejection
        function(dismiss) {
          if (dismiss === 'timer') {
            console.log('I was closed by the timer')
          }
        }
      )
    } else if (type === 'warning-message-and-cancel') {
      swal({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3f51b5',
        cancelButtonColor: '#ff4081',
        confirmButtonText: 'Great ',
        buttons: {
          cancel: {
            text: "Cancel",
            value: null,
            visible: true,
            className: "btn btn-danger",
            closeModal: true,
          },
          confirm: {
            text: "OK",
            value: true,
            visible: true,
            className: "btn btn-primary",
            closeModal: true
          }
        }
      })

    } else if (type === 'custom-html') {
      swal({
        content: {
          element: "input",
          attributes: {
            placeholder: "Type your password",
            type: "password",
            class: 'form-control'
          },
        },
        button: {
          text: "OK",
          value: true,
          visible: true,
          className: "btn btn-primary"
        }
      })
    }
  }

})(jQuery);