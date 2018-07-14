// pull in desired CSS/SASS files
import './styles/main.scss';
import Wishlist from '../js/wishlist';
//var $ = (jQuery = require('../../node_modules/jquery/dist/jquery.js')); // <--- remove if jQuery not needed
//require('../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js'); // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
import Elm from '../elm/Main';
const program = Elm.Main.embed(document.getElementById('main'));
console.log(program);

program.ports.requestWishlists.subscribe(function(userName) {
  console.log('JS: Request wishlists');
  Wishlist.list('test').then(function(wishlistsSnapshot) {
    const wishlists = [];

    wishlistsSnapshot.forEach(doc => {
      wishlists.push(JSON.stringify(doc.data()));
      console.log(`${doc.id} => ${JSON.stringify(doc.data())}`);
    });

    program.ports.requestedWishlists.send(wishlists);
  });
});
