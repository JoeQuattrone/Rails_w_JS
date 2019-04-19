const BASE_URL = 'https://j-travel.herokuapp.com'
// const BASE_URL = 'http://localhost:3000'
function formatDate(date) {

  return `${date.split('-')[1]}/${date.split('-')[2].split('T')[0]}/${date.split('-')[0]}`
}

class Hotel {
  constructor(hash) {
    this.address = hash.address
    this.city = hash.city
    this.id = hash.id
    this.image_url = hash.image_url
    this.name = hash.name
    this.price = hash.price
    this.visits = hash.visits
  }

  render() {
    let visits = this.visits.length
    let template =  `<div class="row hotel-row">
      <div class="col-sm" id="image">
        <img src="${this.image_url}">
      </div>
      <div class="col-md-6" id="hotel-info-list-${this.id}">
        <a href="hotels/${this.id}" class="hotel-link">
          <h4>${this.name}</h4>
          <p>${this.city}</p>
          <p>${this.address}</p>
        </a>
      </div>
      <div class="col-sm price-div">
        <a href="hotels/${this.id}">
          <h2 class="price">$${this.price}</h2>
          <p>per night</p>
        </a>
      </div>
    </div>`

    document.querySelector("#hotel-container").innerHTML += template
    if(visits > 0) {
      $(`#hotel-info-list-${this.id}`).append(`<p>${visits} other's have booked this hotel!</p>`)
    }
  }
}


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
      <h5>${formatDate(this.start_visit)} - ${formatDate(this.end_visit)}</h5>
      <br>
      <form action="/users/${this.user_id}/visits/${this.id}" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="_method" value="delete"><input type="hidden" name="authenticity_token" value="/52zdE7Gqmkgi3Sa7TL4WqUN3MrKl/eyMRsY/oIj7q7chWliqv+Z89E+2ZwFYbaWAAdgzhc6Vqd951RIpIzWSQ==">
      <a class="btn btn-primary" id="home-btn" href="/users/${this.user_id}/visits">MY TRIPS</a>
      <input type="submit" name="commit" value="DELETE TRIP" class="btn btn-danger">
      </form>
    </div>
    `
    document.querySelector("#js-render").innerHTML = template
  }
}

class VisitWithHotel {
  constructor(hash) {
    this.id = hash.id
    this.start_visit = hash.start_visit
    this.end_visit = hash.end_visit
    this.user_id = hash.user_id
    this.created_at = hash.created_at
    this.updated_at = hash.updated_at
    this.hotel = {
      "address": hash.hotel.address,
      "city": hash.hotel.city,
      "id": hash.hotel.id,
      "image_url": hash.hotel.image_url,
      "name": hash.hotel.name,
      "price": hash.hotel.price
    }
  }
  nextVisit() {
    $('#visit_id').val(this.id)
    $('#hotel-img').html(`<img src="${this.hotel.image_url}">`)
    $('#hotel-info').html(`
      <h4>${this.hotel.name}</h4>
      <p>${this.hotel.city.toUpperCase()}</p>
      <p>${this.hotel.address}</p>
      `)
    $('#hotel-price').html(`
      <h2>$${this.hotel.price}</h2>
      <p>per night</p>
      `)
    $('#visit-dates').html(`${formatDate(this.start_visit)} - ${formatDate(this.end_visit)}`)
  }
}



$(function() {
  $('#js-search').submit(function(e) {
    e.preventDefault()
    let city = $("#hotel_city").val()
    let budget = $("#hotel_budget").val()
    let url = `${BASE_URL}/search`
    let data = { hotel: {
      city: city,
      budget: budget
    }}
    document.querySelector("#hotel-container").innerHTML = ""
    fetch(url, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: { 'Content-Type': 'application/json' }
    }).then(res => res.json())
    .then(function(json) {
      console.log(json)
      json.forEach(function(hotel_data) {
        let hotel = new Hotel(hotel_data)
        hotel.render() })
      })
    })
  })


$(function() {
  $("#create-visit").submit(function(e) {
    e.preventDefault()
    let hotel_id = $('#hotel_id').val()
    let user_id = $('#user_id').val()
    let start_visit = $('#start_visit').val()
    let end_visit = $('#end_visit').val()
    let url = `${BASE_URL}/hotels/${hotel_id}/visits/last`
    let data = {
      user_id: user_id,
      hotel_id: hotel_id,
      start_visit: start_visit,
      end_visit: end_visit
    }
     $.ajax({
        url : url,
        data : JSON.stringify(data),
        type : 'POST',
        contentType : 'application/json',
        processData: false,
        dataType: 'json'
      }).done(function(json) { let visit = new Visit(json)
        visit.render()
      })
  })
})


$(function() {
  $('#next-btn').click(function(e) {
    e.preventDefault()
    let user_id = $('#user_id').val()
    let visit_id = $('#visit_id').val()
    let url = `${BASE_URL}/users/${user_id}/visits/${visit_id}/next`
    fetch(url)
      .then(res => res.json())
      .then(function(json) {
        let visit = new VisitWithHotel(json)
        visit.nextVisit()
      })
  })
})
