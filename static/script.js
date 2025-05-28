// Smooth Scroll for Nav Links
document.querySelectorAll('a.nav-link').forEach(anchor => {
  anchor.addEventListener('click', function (e) {
    e.preventDefault();
    document.querySelector(this.getAttribute('href')).scrollIntoView({
      behavior: 'smooth'
    });
  });
});

// Fade-in Animation on Scroll
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.fade-in').forEach(element => {
  observer.observe(element);
});

// Pause/resume carousels on hover
document.querySelectorAll('.carousel').forEach(carousel => {
  carousel.addEventListener('mouseover', () => {
    bootstrap.Carousel.getInstance(carousel).pause();
  });
  carousel.addEventListener('mouseout', () => {
    bootstrap.Carousel.getInstance(carousel).cycle();
  });
});

// Back to Top Button
const backToTopButton = document.getElementById('backToTop');
window.addEventListener('scroll', () => {
  backToTopButton.style.display = window.scrollY > 300 ? 'block' : 'none';
});
backToTopButton.addEventListener('click', () => {
  window.scrollTo({ top: 0, behavior: 'smooth' });
});

// Helper to create alert boxes
function createAlert(message, type) {
  const alert = document.createElement('div');
  alert.className = `alert alert-${type} mt-3`;
  alert.textContent = message;
  return alert;
}

// Subscribe Form Handling
document.getElementById('subscribeForm').addEventListener('submit', function (e) {
  e.preventDefault();
  const emailInput = document.getElementById('email');
  const email = emailInput.value.trim();

  // Simple frontend validation
  if (!email || !email.includes('@')) {
    const error = createAlert('Please enter a valid email address.', 'danger');
    this.appendChild(error);
    setTimeout(() => error.remove(), 3000);
    return;
  }

  // Submit to Flask
  fetch('/subscribe', {
    method: 'POST',
    body: new URLSearchParams({ email }),
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
  })
  .then(res => res.json())
  .then(data => {
    const success = createAlert(data.message, 'success');
    this.appendChild(success);
    emailInput.value = '';
    setTimeout(() => success.remove(), 3000);
  })
  .catch(err => {
    const fail = createAlert('Subscription failed. Try again later.', 'danger');
    this.appendChild(fail);
    setTimeout(() => fail.remove(), 3000);
  });
});

// Contact Form Handling
document.querySelector('#contact form').addEventListener('submit', function (e) {
  e.preventDefault();
  const name = this.name.value.trim();
  const email = this.email.value.trim();
  const message = this.message.value.trim();

  // Basic frontend validation
  if (!email || !email.includes('@') || !message) {
    const error = createAlert('Please enter a valid email and message.', 'danger');
    this.appendChild(error);
    setTimeout(() => error.remove(), 3000);
    return;
  }

  // Submit to Flask
  fetch('/contact', {
    method: 'POST',
    body: new URLSearchParams({ name, email, message }),
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
  })
  .then(res => res.json())
  .then(data => {
    const success = createAlert(data.message, 'success');
    this.appendChild(success);
    this.reset();
    setTimeout(() => success.remove(), 3000);
  })
  .catch(err => {
    const fail = createAlert('Message failed to send. Try again later.', 'danger');
    this.appendChild(fail);
    setTimeout(() => fail.remove(), 3000);
  });
});

let cart = JSON.parse(localStorage.getItem('cart')) || {};

function saveCart() {
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
}

function updateCartCount() {
  const count = Object.values(cart).reduce((sum, item) => sum + item.quantity, 0);
  document.getElementById('cartCount').textContent = count;
}

let cartModalInstance = null;  // Declare a global variable to hold the modal instance

function openCart() {
  const cartItems = document.getElementById('cartItems');
  cartItems.innerHTML = ''; // Clear cart contents

  let total = 0;
  for (const id in cart) {
    const item = cart[id];
    total += item.price * item.quantity;
    cartItems.innerHTML += `
      <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
        <div>
          <strong>${item.name}</strong><br>
          $${item.price} × 
          <input type="number" value="${item.quantity}" min="1" class="form-control d-inline" 
                 style="width:70px;" onchange="updateQuantity('${id}', this.value)">
        </div>
        <button class="btn btn-sm btn-danger" onclick="removeFromCart('${id}')">Remove</button>
      </div>
    `;
  }

  document.getElementById('cartTotal').textContent = total.toFixed(2);

  // Reuse the existing modal instance
  const cartModalEl = document.getElementById('cartModal');
  if (!cartModalInstance) {
    cartModalInstance = new bootstrap.Modal(cartModalEl);  // Create the instance once
  }
  cartModalInstance.show();  // Show the modal
}

function updateQuantity(id, qty) {
  cart[id].quantity = parseInt(qty);
  saveCart();
  openCart(); // Refresh modal
}

function removeFromCart(id) {
  delete cart[id];
  saveCart();
  openCart(); // Refresh modal
}

function checkout() {
  const items = JSON.stringify(cart);
  const total = Object.values(cart).reduce((sum, item) => sum + item.price * item.quantity, 0);

  fetch('/checkout', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: new URLSearchParams({
      items,
      total
    })
  })
  .then(res => res.json())
  .then(data => {
    alert(data.message || 'Order placed!');
    cart = {};
    saveCart();
    cartModalInstance.hide();
  })
  .catch(err => {
    alert('Failed to place order. Please try again.');
  });
}

// Add-to-cart button event
document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const id = btn.dataset.id;
    if (!cart[id]) {
      cart[id] = {
        name: btn.dataset.name,
        price: parseFloat(btn.dataset.price),
        quantity: 1
      };
    } else {
      cart[id].quantity += 1;
    }
    saveCart();
  });
});

updateCartCount(); // On page load
