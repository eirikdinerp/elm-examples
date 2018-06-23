// pull in desired CSS/SASS files
import './styles/main.scss';
import Wishlist from '../js/wishlist';
//var $ = (jQuery = require('../../node_modules/jquery/dist/jquery.js')); // <--- remove if jQuery not needed
//require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js'); // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
import Elm from '../elm/Main';
Elm.Main.embed(document.getElementById('main'));

Wishlist.list('test').then(function(wishlistsSnapshot) {
  wishlistsSnapshot.forEach(doc => {
    console.log(`${doc.id} => ${JSON.stringify(doc.data())}`);
  });
});
