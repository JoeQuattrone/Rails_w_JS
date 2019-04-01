// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

class Hotel {
  constructor(hash) {
    this.address = hash.address
    this.city = hash.city
    this.id = hash.id
    this.image_url = hash.image_url
    this.name = hash.name
    this.price = hash.price
  }

  render() {
    let template =  `<div class="row hotel-row">
      <div class="col-sm" id="image">
        <img src="${this.image_url}">
      </div>
      <div class="col-md-6">
        <a href="hotels/${this.id}" class="hotel-link">
          <h4>${this.name}</h4>
          <p>${this.city}</p>
          <p>${this.address}</p>
        </a>
      </div>
      <div class="col-sm">
        <a href="hotels/${this.id}">
          <h2 class="price">$${this.price}</h2>
          <p>per night</p>
        </a>
      </div>
    </div>`

    document.querySelector("#hotel-container").innerHTML += template
  }

}
