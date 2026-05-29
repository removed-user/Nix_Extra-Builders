function carryByShip() {
  console.log("By ship");
}

function carryByPlane() {
  console.log("By plane");
}

function deliver(carry: () => void) {
  console.log("Shipping");
  carry();
  console.log("Receipt");
}

deliver(carryByShip); // Shipping, By ship, Receipt
deliver(carryByPlane); // Shipping, By plane, Receipt
