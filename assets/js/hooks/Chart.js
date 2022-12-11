import { Chart } from "../../vendor/chart"

export default {
  mounted() {
    this.chartContext = this.el.getContext('2d')
    const defaultDatasetOpts = {
      fill: false,
      borderColor: "rgb(75, 192, 192)",
      tension: 0.1
    }

    this.handleEvent("render-chart", (data) => {
      if (data.id !== this.el.id) return

      this.chart = new Chart(this.chartContext, {
        type: "line",
        data: {
          labels: data.labels,
          datasets: data.datasets.map(dataset => Object.assign({}, defaultDatasetOpts, dataset))
        }
      })
    })
  }
}
