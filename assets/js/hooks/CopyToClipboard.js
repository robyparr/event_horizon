export default {
  mounted() {
    const target = this.el.dataset.target
    this.el.addEventListener('click', (event) => {
      event.preventDefault()

      const targetEl = document.querySelector(target)
      let text = targetEl.value || targetEl.innerHTML

      navigator.clipboard.writeText(text).then(() => {
        const originalHTML = this.el.innerHTML
        this.el.innerHTML = "✅"
        setTimeout(() => this.el.innerHTML = originalHTML, 2000)
      })
    })
  }
}
