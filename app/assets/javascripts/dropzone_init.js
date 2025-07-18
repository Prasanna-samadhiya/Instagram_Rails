document.addEventListener("DOMContentLoaded", function () {
  Dropzone.autoDiscover = false;

  const initDropzone = (selector, fieldName, formId) => {
    const el = document.querySelector(selector);
    if (!el) return;

    new Dropzone(selector, {
      url: "/uploads",
      paramName: "file",
      maxFiles: 1,
      acceptedFiles: "image/*,video/*",
      addRemoveLinks: true,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      success: function (file, response) {
        const hiddenInput = document.createElement("input");
        hiddenInput.type = "hidden";
        hiddenInput.name = fieldName;
        hiddenInput.value = response.signed_id;
        document.querySelector(formId).appendChild(hiddenInput);
      }
    });
  };

  initDropzone("#my-dropzone", "post[image]", "#post-upload-form");
  initDropzone("#avatar-dropzone", "user[avatar]", ".form-edit-user");
});