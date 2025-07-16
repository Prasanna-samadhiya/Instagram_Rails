document.addEventListener("DOMContentLoaded", function () {
  if (document.querySelector("#my-dropzone")) {
    const dropzone = new Dropzone("#my-dropzone", {
      url: "/uploads", // You’ll create this endpoint
      maxFiles: 1,
      paramName: "file", 
      addRemoveLinks: true,
      acceptedFiles: "image/*",

      success: function (file, response) {
        // Assign signed blob ID to the hidden field
        const hiddenInput = document.querySelector('input[name="post[image]"]');
        hiddenInput.value = response.signed_id;
      }
    });
  }
});