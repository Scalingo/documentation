module.exports = {
  content: [
    "./src/**/*.{html,erb,md,mdown,css}",
  ],
  theme: {
    fontFamily: {
      sans: ["aktiv-grotesk"],
      serif: ["freight-text-pro"],
    },
    colors: {
      "sc-gray-1": "#1F2933",
      "sc-gray-2": "#7B8794",
      "sc-gray-3": "#E5E7EA",
      "sc-gray-4": "#F8F9FA",
      "sc-gray-5": "#FFFFFF",
      "sc-blue-1": "#183BEE",
      "sc-blue-2": "#D1D8FC",
      "sc-blue-3": "#F8F9FF",
      "sc-turquoise-1": "#22D1EE",
      "sc-turquoise-2": "#A7EDF8",
      "sc-turquoise-3": "#E9FAFD",
      "sc-yellow-1": "#FFD600",
      "sc-yellow-2": "#FFD600",
      "sc-yellow-3": "#FFFBE5",
    },
    fontSize: {
      "sc-text-1": [
        "18px",
        {
          lineHeight: "38px"
        },
      ],
      "sc-title-1": [
        "32px",
        {
          lineHeight: "28px",
          letterSpacing: "-0.04em",
        },
      ],
      "sc-title-2": [
        "24px",
        {
          lineHeight: "28px",
          letterSpacing: "-0.04em",
        },
      ],
      "sc-title-3": [
        "22px",
        {
          lineHeight: "28px",
          letterSpacing: "-0.04em",
        },
      ],
      "sc-title-4": [
        "20px",
        {
          lineHeight: "28px",
          letterSpacing: "-0.04em",
        },
      ],
      "sc-title-5": [
        "18px",
        {
          lineHeight: "28px",
          letterSpacing: "-0.04em",
        },
      ],
    }
  },
  plugins: [],
};
