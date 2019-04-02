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

$(function() {
  $('#js-search').submit(function(e) {
    e.preventDefault()
    document.querySelector("#hotel-container").innerHTML = ""
    let city = $("#hotel_city").val()
    let budget = $("#hotel_budget").val()
    let url = "http://localhost:3000/search"
    let data = { hotel: {
      city: city,
      budget: budget
    }}
    fetch(url, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: { 'Content-Type': 'application/json' }
    }).then(res => res.json())
      .then(json => json.forEach(function(hotel_data) {
        let hotel = new Hotel(hotel_data)
        hotel.render()
      }))
  })
})

class Visit {
  constructor(hash) {
    this.id = hash.id
    this.start_visit = hash.start_visit
    this.end_visit = hash.end_visit
    this.user_id = hash.user_id
    this.created_at = hash.created_at
    this.updated_at = hash.updated_at
  }

  render() {
    let template = `
    <div class="text-center">
      <h4>Thank You For Booking With J-Travel<h4>
      <h5>${this.start_visit} - ${this.end_visit}</h5>
      <br>
      <form action="/users/${this.user_id}/visits/${this.id}" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="_method" value="delete"><input type="hidden" name="authenticity_token" value="/52zdE7Gqmkgi3Sa7TL4WqUN3MrKl/eyMRsY/oIj7q7chWliqv+Z89E+2ZwFYbaWAAdgzhc6Vqd951RIpIzWSQ==">
      <a class="btn btn-primary" id="home-btn" href="/users/1/visits">MY TRIPS</a>
      <input type="submit" name="commit" value="DELETE TRIP" class="btn btn-danger">
      </form>
    </div>
    `
    document.querySelector("#js-render").innerHTML = ''
    document.querySelector("#js-render").innerHTML += template
  }
}
