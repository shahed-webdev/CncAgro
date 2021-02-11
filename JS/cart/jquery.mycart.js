/*
* jQuery myCart - v1.5 - 2017-10-23
* http://asraf-uddin-ahmed.github.io/
* Copyright (c) 2017 Asraf Uddin Ahmed; Licensed None
*/

(function ($) {
  "use strict";
  var OptionManager = (function () {
    var objToReturn = {};

    var _options = null;
    var DEFAULT_OPTIONS = {
      currencySymbol: '৳',
      classCartIcon: 'my-cart-icon',
      classCartBadge: 'my-cart-badge',
      classProductQuantity: 'my-product-quantity',
      classProductRemove: 'my-product-remove',
      classCheckoutCart: 'my-cart-checkout',
      affixCartIcon: true,
      showCheckoutModal: true,
      numberOfDecimals: 2,
      cartItems: null,
      clickOnAddToCart: function($addTocart) { },
      afterAddOnCart: function(products, totalPrice, totalQuantity) { },
      clickOnCartIcon: function($cartIcon, products, totalPrice, totalQuantity) { },
      checkoutCart: function(products, totalPrice,totalQuantity, totalCommission,totalPoint) { },
      getDiscountPrice: function(products, totalPrice, totalQuantity) { return null; }
    };


    var loadOptions = function (customOptions) {
      _options = $.extend({}, DEFAULT_OPTIONS);
      if (typeof customOptions === 'object') {
        $.extend(_options, customOptions);
      }
    }
    var getOptions = function () {
      return _options;
    }

    objToReturn.loadOptions = loadOptions;
    objToReturn.getOptions = getOptions;
    return objToReturn;
  }());

  var MathHelper = (function() {
    var objToReturn = {};
    var getRoundedNumber = function(number){
      if(isNaN(number)) {
        throw new Error('Parameter is not a Number');
      }
      number = number * 1;
      var options = OptionManager.getOptions();
      return number.toFixed(options.numberOfDecimals);
    }
    objToReturn.getRoundedNumber = getRoundedNumber;
    return objToReturn;
  }());

  var ProductManager = (function(){
    var objToReturn = {};
    /*PRIVATE*/
    localStorage.products = localStorage.products ? localStorage.products : "";

    var getIndexOfProduct = function(id){
      var productIndex = -1;
      var products = getAllProducts();
      $.each(products, function(index, value){
        if(value.id === id){
          productIndex = index;
          return;
        }
      });
      return productIndex;
    }
    var setAllProducts = function(products){
      localStorage.products = JSON.stringify(products);
    }
    var addProduct = function (id, name, summary, price, quantity, image, stock, commission, point) {
      var products = getAllProducts();
      products.push({
        id: id,
        name: name,
        summary: summary,
        price: price,
        quantity: quantity,
        image: image,
        stock: stock,
        commission: commission,
        point: point
      });
      setAllProducts(products);
    }

    /*
    PUBLIC
    */
    var getAllProducts = function(){
      try {
        var products = JSON.parse(localStorage.products);
        return products;
      } catch (e) {
        return [];
      }
    }

    var updatePoduct = function(id, quantity) {
      var productIndex = getIndexOfProduct(id);
      if(productIndex < 0){
        return false;
      }
      var products = getAllProducts();
      products[productIndex].quantity = typeof quantity === "undefined" ? products[productIndex].quantity * 1: quantity;
      setAllProducts(products);
      return true;
    }

    var setProduct = function (id, name, summary, price, quantity, image, Stock, commission, point) {
      if(typeof id === "undefined"){
        console.error("id required")
        return false;
      }
      if(typeof name === "undefined"){
        console.error("name required")
        return false;
      }
      if(typeof image === "undefined"){
        console.error("image required")
        return false;
      }
      if(!$.isNumeric(price)){
        console.error("price is not a number")
        return false;
      }
      if(!$.isNumeric(quantity)) {
        console.error("quantity is not a number");
        return false;
      }
      if (!$.isNumeric(Stock)) {
          console.error("Stock is not a number");
          return false;
      }
      if (!$.isNumeric(commission)) {
          console.error("commission is not a number");
          return false;
      }
      if (!$.isNumeric(point)) {
          console.error("Point is not a number");
          return false;
      }
      summary = typeof summary === "undefined" ? "" : summary;

      if(!updatePoduct(id)){
          addProduct(id, name, summary, price, quantity, image, Stock, commission, point);
      }
    }

    var clearProduct = function(){
      setAllProducts([]);
    }

    var removeProduct = function(id){
      var products = getAllProducts();
      products = $.grep(products, function(value, index) {
        return value.id !== id;
      });
      setAllProducts(products);
    }

    var getTotalQuantity = function(){
      var total = 0;
      var products = getAllProducts();
      $.each(products, function(index, value){
        total += value.quantity * 1;
      });
      return total;
    }

    var getTotalPrice = function(){
      var products = getAllProducts();
      var total = 0;
      $.each(products, function(index, value){
        total += value.quantity * value.price;
        total = MathHelper.getRoundedNumber(total) * 1;
      });
      return total;
    }

    var getTotaCommission = function () {
        var products = getAllProducts();
        var total = 0;
        $.each(products, function (index, value) {
            total += value.commission * value.quantity;
            total = MathHelper.getRoundedNumber(total) * 1;
        });
        return total;
    }

    var getTotalPoint = function () {
        var products = getAllProducts();
        var total = 0;
        $.each(products, function (index, value) {
            total += value.point * value.quantity;
            total = MathHelper.getRoundedNumber(total) * 1;
        });
        return total;
    }

    objToReturn.getAllProducts = getAllProducts;
    objToReturn.updatePoduct = updatePoduct;
    objToReturn.setProduct = setProduct;
    objToReturn.clearProduct = clearProduct;
    objToReturn.removeProduct = removeProduct;
    objToReturn.getTotalQuantity = getTotalQuantity;
    objToReturn.getTotalPrice = getTotalPrice;
    objToReturn.getTotaCommission = getTotaCommission;
    objToReturn.getTotalPoint = getTotalPoint;
    return objToReturn;
  }());

  var loadMyCartEvent = function(targetSelector){

      var options = OptionManager.getOptions();
      var $cartIcon = $("." + options.classCartIcon);
      var $cartBadge = $("." + options.classCartBadge);
      var classProductQuantity = options.classProductQuantity;
      var classProductRemove = options.classProductRemove;
      var classCheckoutCart = options.classCheckoutCart;


      var idAvaliableBalance= 'my-balance';
      var idCartModal = 'my-cart-modal';
      var idCartTable = 'my-cart-table';
      var idGrandTotal = 'my-cart-grand-total';
      var idCommissionTotal = 'my-cart-commission-total';
      var idPointTotal = 'my-cart-Point-Total';
      var idEmptyCartMessage = 'my-cart-empty-message';
      var idDiscountPrice = 'my-cart-discount-price';
      var classProductTotal = 'my-product-total';
      var classAffixMyCartIcon = 'my-cart-icon-affix';


      if(options.cartItems && options.cartItems.constructor === Array) {
          ProductManager.clearProduct();
          $.each(options.cartItems, function() {
              ProductManager.setProduct(this.id, this.name, this.summary, this.price, this.quantity, this.image, this.Stock, this.commission, this.point);
          });
      }

      $cartBadge.text(ProductManager.getTotalQuantity());

      if(!$("#" + idCartModal).length) {
          $('body').append(
            '<div class="modal fade" id="' + idCartModal + '" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">' +
            '<div class="modal-dialog modal-lg" role="document">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
            '<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-shopping-cart"></span> Shopping Cart</h4>' +
            '</div>' +
            '<div class="modal-body" style="padding-bottom: 0;">' +
            '<table class="table table-hover table-responsive" id="' + idCartTable + '"></table>' +
            '</div>' +
            '<div class="modal-footer">' +
            '<button type="button" class="btn btn-primary ' + classCheckoutCart + '">Confirm Order</button>' +
            '<br/><label class="alert-danger Balance_error"></label>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>'
          );
      }

      var drawTable = function(){
          var $cartTable = $("#" + idCartTable);
          $cartTable.empty();
      
          var products = ProductManager.getAllProducts();
          $cartTable.append(products.length ? '<tr><th>Name</th><th>Price</th><th>Point</th><th>Quantity</th><th>Total</th><th></th></tr>' : '');
          $.each(products, function(){
              var total = this.quantity * this.price;
              var Point_total = this.quantity * this.point;
              $cartTable.append(
                '<tr data-stock="' + this.stock + '" data-point="' + this.point + '" data-id="' + this.id + '" data-price="' + this.price + '">' +
                '<td>' + this.name + '</td>' +
                '<td>' + options.currencySymbol + MathHelper.getRoundedNumber(this.price) + '</td>' +
                '<td class="Point_Total">' + Point_total + '</td>' +
                '<td><input type="number" title="Current Stock: ' + this.stock + '" max="' + this.stock + '" min="1" class="' + classProductQuantity + '" value="' + this.quantity + '"/></td>' +
                '<td class="' + classProductTotal + '">' + options.currencySymbol  + MathHelper.getRoundedNumber(total) + '</td>' +
                '<td class="text-center" style="width:8px;"><a href="javascript:void(0);" class="' + classProductRemove + '"><i class="fas fa-trash"></i></a></td>' +
                '</tr>'
              );
          });

          $cartTable.append(products.length ?
            '<tr>' +
            '<td><strong>Total</strong></td>' +
            '<td></td>' +
            '<td><strong id="' + idPointTotal + '"></strong></td>' +
            '<td></td>' +
            '<td><strong id="' + idGrandTotal + '"></strong></td>' +
            '<td></td>' +
            '</tr>' +

            '<tr class="classTotalCommission">' +
            '<td><strong>Commission</strong></td>' +
            '<td></td>' +
            '<td></td>' +
            '<td></td>' +
            '<td><strong id="' + idCommissionTotal + '"></strong></td>' +
            '<td></td>' +
            '</tr>'+

            '<tr>' +
            '<td><strong>Net</strong></td>' +
            '<td></td>' +
            '<td></td>' +
            '<td></td>' +
            '<td><strong id="NetAmnt"></strong></td>' +
            '<td></td>' +
            '</tr>'

            :'<div class="alert alert-danger" id="' + idEmptyCartMessage + '">Your cart is empty</div>'
          );


          //var discountPrice = options.getDiscountPrice(products, ProductManager.getTotalPrice(), ProductManager.getTotalQuantity());
          //if(products.length && discountPrice !== null) {
          //  $cartTable.append(
          //    '<tr style="color: red">' +
          //    '<td><strong>Total (including discount)</strong></td>' +
          //    '<td></td>' +
          //    '<td></td>' +
          //    '<td><strong id="' + idDiscountPrice + '"></strong></td>' +
          //    '<td></td>' +
          //    '</tr>'
          //  );
          //}

          showGrandTotal();
          showCommissionTotal();
          showPointTotal();
          showNetAmount();
      }
      var showModal = function(){
          drawTable();
          $("#" + idCartModal).modal('show');
      }
      var updateCart = function(){
          $.each($("." + classProductQuantity), function(){
              var id = $(this).closest("tr").data("id");
              ProductManager.updatePoduct(id, $(this).val());
          });
      }
      var showGrandTotal = function(){
          $("#" + idGrandTotal).text(options.currencySymbol + MathHelper.getRoundedNumber(ProductManager.getTotalPrice()));
      }

      var showCommissionTotal = function () {
          $("#" + idCommissionTotal).text(options.currencySymbol + MathHelper.getRoundedNumber(ProductManager.getTotaCommission()));
      }

      var showPointTotal = function () {
          $("#" + idPointTotal).text(ProductManager.getTotalPoint()+' Point');
      }

      var showNetAmount = function(){
          $("#NetAmnt").text(options.currencySymbol + MathHelper.getRoundedNumber((ProductManager.getTotalPrice() - ProductManager.getTotaCommission())));
      }

      /*
      EVENT
      */
      if(options.affixCartIcon) {
          var cartIconBottom = $cartIcon.offset().top * 1 + $cartIcon.css("height").match(/\d+/) * 1;
          var cartIconPosition = $cartIcon.css('position');
          $(window).scroll(function () {
              $(window).scrollTop() >= cartIconBottom ? $cartIcon.addClass(classAffixMyCartIcon) : $cartIcon.removeClass(classAffixMyCartIcon);
          });
      }

      $cartIcon.click(function(){
          options.showCheckoutModal ? showModal() : options.clickOnCartIcon($cartIcon, ProductManager.getAllProducts(), ProductManager.getTotalPrice(), ProductManager.getTotalQuantity());
      });

      $(document).on("input", "." + classProductQuantity, function () {
          var price = $(this).closest("tr").data("price");
          var point = $(this).closest("tr").data("point");
          var id = $(this).closest("tr").data("id");
          var Stock = $(this).closest("tr").data('stock');
          var quantity = $(this).val();

          if (Stock <= quantity) {
              quantity = Stock;
              $(this).val(Stock);
          }

          $(this).parent("td").next("." + classProductTotal).text(options.currencySymbol + MathHelper.getRoundedNumber(price * quantity));
          $(this).parent("td").prev(".Point_Total").text(point * quantity);

          ProductManager.updatePoduct(id, quantity);
          $cartBadge.text(ProductManager.getTotalQuantity());

          showGrandTotal();
          showCommissionTotal();
          showPointTotal();
          showNetAmount();
      });

    $(document).on('keypress', "." + classProductQuantity, function(a){
       a = a.which ? a.which : event.keyCode; return 46 !== a && 31 < a && (48 > a || 57 < a) ? !1 : !0 
    });

    $(document).on('click', "." + classProductRemove, function(){
      var $tr = $(this).closest("tr");
      var id = $tr.data("id");
      $tr.hide(500, function(){
        ProductManager.removeProduct(id);
        drawTable();
        $cartBadge.text(ProductManager.getTotalQuantity());
      });
    });

      //Checkout button
    $(document).on('click', "." + classCheckoutCart, function(){
      var products = ProductManager.getAllProducts();
      if(!products.length) {
        $("#" + idEmptyCartMessage).fadeTo('fast', 0.5).fadeTo('fast', 1.0);
        return ;
      }
      var total_Price = (ProductManager.getTotalPrice() - ProductManager.getTotaCommission());
      var avilable_balance = $("#" + idAvaliableBalance).val();

      if (total_Price <= avilable_balance) {
          updateCart();
          options.checkoutCart(ProductManager.getAllProducts(), ProductManager.getTotalPrice(), ProductManager.getTotaCommission(), ProductManager.getTotalPoint());
          ProductManager.clearProduct();
          $cartBadge.text(ProductManager.getTotalQuantity());
          $("#" + idCartModal).modal("hide");
          $(".Balance_error").text("");
      }
      else {
          $(".Balance_error").text("You don't have enough balance. Your current balance: " + avilable_balance + " tk");
          setTimeout(function () { $(".Balance_error").text("")}, 6000);
      }
    });

    $(document).on('click', targetSelector, function(){
      var $target = $(this);
      options.clickOnAddToCart($target);

      var id = $target.data('id');
      var name = $target.data('name');
      var summary = $target.data('summary');
      var price = $target.data('price');
      var quantity = $target.data('quantity');
      var image = $target.data('image');
      var stock = $target.data('stock');
      var commission = $target.data('commission');
      var point = $target.data('point');


      ProductManager.setProduct(id, name, summary, price, quantity, image, stock, commission, point);
      $cartBadge.text(ProductManager.getTotalQuantity());

      options.afterAddOnCart(ProductManager.getAllProducts(), ProductManager.getTotalPrice(), ProductManager.getTotalQuantity());
    });
  }


  $.fn.myCart = function (userOptions) {
    OptionManager.loadOptions(userOptions);
    loadMyCartEvent(this.selector);
    return this;
  }


})(jQuery);
