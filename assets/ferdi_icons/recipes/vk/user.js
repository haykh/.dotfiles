module.exports = (config, Ferdium) => {
  // Write your scripts here
  window.onload = function () {
    if (window.location.href == "https://vk.com/feed") {
      window.location.replace('https://vk.com/im');
    }
  }
  console.log("Hello, World!", config);
};
