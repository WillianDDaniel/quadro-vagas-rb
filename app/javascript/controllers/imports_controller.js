import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropZone", "input", "fileName"]

  connect() {
    this.dropZoneTarget.addEventListener("dragover", this.handleDragOver.bind(this));
    this.dropZoneTarget.addEventListener("dragleave", this.handleDragLeave.bind(this));
    this.dropZoneTarget.addEventListener("drop", this.handleDrop.bind(this));

    this.inputTarget.addEventListener("change", this.handleInputChange.bind(this));
  }

  handleDragOver(event) {
    event.preventDefault();
    event.stopPropagation();
    this.dropZoneTarget.classList.add("border-blue-500");
  }

  handleDragLeave(event) {
    event.preventDefault();
    event.stopPropagation();
    this.dropZoneTarget.classList.remove("border-blue-500");
  }

  handleDrop(event) {
    event.preventDefault();
    event.stopPropagation();

    this.dropZoneTarget.classList.remove("border-blue-500");
    if (event.dataTransfer.files && event.dataTransfer.files.length > 0) {
      this.inputTarget.files = event.dataTransfer.files;
      this.displayFileName(event.dataTransfer.files[0]);
      event.dataTransfer.clearData();
    }
  }

  handleInputChange(event) {
    if (this.inputTarget.files && this.inputTarget.files.length > 0) {
      this.displayFileName(this.inputTarget.files[0]);
    }
  }

  displayFileName(file) {
    this.fileNameTarget.classList.remove("hidden");
    this.fileNameTarget.innerHTML = `
      <div class="flex items-center p-3 bg-emerald-50 border border-emerald-200 rounded-lg">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-emerald-500 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <span class="font-medium text-emerald-700">${file.name}</span>
        <span class="ml-auto text-xs text-emerald-600">${Math.round(file.size / 1024)} KB</span>
      </div>
    `;
  }
}