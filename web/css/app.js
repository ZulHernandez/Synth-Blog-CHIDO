/* -----------------------------------------------
/* How to use? : Check the GitHub README
/* ----------------------------------------------- */

/* To load a config file (particles.json) you need to host this demo (MAMP/WAMP/local)... */
/*
particlesJS.load('particles-js', 'particles.json', function() {
  console.log('particles.js loaded - callback');
});
*/

/* Otherwise just put the config content (json): */

particlesJS('particles-js',
{
  "particles": {
    "number": {
      "value": 137,
      "density": {
        "enable": true,
        "value_area": 800
      }
    },
    "color": {
      "value": "#000000"
    },
    "shape": {
      "type": "image",
      "stroke": {
        "width": 0,
        "color": "#000000"
      },
      "polygon": {
        "nb_sides": 3
      },
      "image": {
        "src": "notas.png",
        "width": 100,
        "height": 100
      }
    },
    "opacity": {
      "value": 0.11048066982851817,
      "random": false,
      "anim": {
        "enable": false,
        "speed": 1,
        "opacity_min": 0.1,
        "sync": false
      }
    },
    "size": {
      "value": 15.782952832645451,
      "random": true,
      "anim": {
        "enable": false,
        "speed": 9.59040959040959,
        "size_min": 3.196803196803197,
        "sync": false
      }
    },
    "line_linked": {
      "enable": true,
      "distance": 110.48066982851817,
      "color": "#000000",
      "opacity": 1,
      "width": 1.1048066982851816
    },
    "move": {
      "enable": true,
      "speed": 3.206824121731046,
      "direction": "right",
      "random": false,
      "straight": true,
      "out_mode": "out",
      "bounce": false,
      "attract": {
        "enable": true,
        "rotateX": 641.3648243462092,
        "rotateY": 1200
      }
    }
  },
  "interactivity": {
    "detect_on": "window",
    "events": {
      "onhover": {
        "enable": true,
        "mode": "repulse"
      },
      "onclick": {
        "enable": true,
        "mode": "grab"
      },
      "resize": true
    },
    "modes": {
      "grab": {
        "distance": 400,
        "line_linked": {
          "opacity": 1
        }
      },
      "bubble": {
        "distance": 323.67632367632365,
        "size": 19.98001998001998,
        "duration": 3.3566433566433567,
        "opacity": 0.6713286713286714,
        "speed": 3
      },
      "repulse": {
        "distance": 111.8881118881119,
        "duration": 0.4
      },
      "push": {
        "particles_nb": 4
      },
      "remove": {
        "particles_nb": 2
      }
    }
  },
  "retina_detect": true
}
);