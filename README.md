<img width="1284" height="239" alt="IMG_9556" src="https://github.com/user-attachments/assets/d0891751-b20d-43e9-8052-1374ce15452f" />

# 📏 RulerView (UIKit)

A lightweight, customizable **ruler-style time picker** built using `UICollectionView` in UIKit.

Perfect for:

* ⏱ Screen recording timers
* 🎬 Video editors
* 📷 Camera apps
* ⚙️ Custom duration pickers

---

## ✨ Features

* Smooth horizontal scrolling
* Center indicator with snapping
* Real-time value updates
* Haptic feedback support
* Gradient edge fading (iOS-style)
* Fully customizable range & step
* Lightweight (no third-party dependency)

---

## 📸 Preview

> Ruler-style time selection with center indicator and gradient fade

---

## 🚀 Installation

Just copy `RulerView.swift` into your project.

No external dependencies required.

---

## 🛠 Usage

### 1. Create instance

```swift
private let rulerView = RulerView()
private let rulerGradientLayer = CAGradientLayer()
```

---

### 2. Setup inside your ViewController

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    setupRuler()
}
```

---

### 3. Layout updates (important for gradient)

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if rulerGradientLayer.frame != rulerScaleView.bounds {
        rulerGradientLayer.frame = rulerScaleView.bounds
    }
}
```

---

### 4. Setup function

```swift
private func setupRuler() {
    
    rulerScaleView.layer.borderWidth = 0.5
    rulerScaleView.layer.borderColor = UIColor.white.withAlphaComponent(0.06).cgColor
    rulerScaleView.layer.cornerRadius = 16
    rulerScaleView.clipsToBounds = true
    rulerScaleView.backgroundColor = .hexStringToUIColor("#272727")
    
    rulerView.translatesAutoresizingMaskIntoConstraints = false
    rulerScaleView.addSubview(rulerView)
    
    NSLayoutConstraint.activate([
        rulerView.leadingAnchor.constraint(equalTo: rulerScaleView.leadingAnchor),
        rulerView.trailingAnchor.constraint(equalTo: rulerScaleView.trailingAnchor),
        rulerView.topAnchor.constraint(equalTo: rulerScaleView.topAnchor),
        rulerView.bottomAnchor.constraint(equalTo: rulerScaleView.bottomAnchor)
    ])
    
    // Configure values
    rulerView.minValue = 0
    rulerView.maxValue = 60
    rulerView.step = 1
    
    // Callback
    rulerView.onValueChange = { [weak self] value in
        print("Selected time: \\(value) min")
        
        self?.selectedCustomValueInMinute?(value)
        self?.lblSelectTime.textColor = .white
    }
    
    if rulerGradientLayer.superlayer == nil {
        rulerScaleView.layer.addSublayer(rulerGradientLayer)
    }
    
    applyRulerGradient()
}
```

---

## 🎨 Gradient (Edge Fade Effect)

Adds a subtle fade on left & right edges — similar to native iOS pickers.

```swift
private func applyRulerGradient() {
    let baseColor = UIColor.hexStringToUIColor("#272727")
    
    rulerGradientLayer.colors = [
        baseColor.cgColor,
        baseColor.withAlphaComponent(0.4).cgColor,
        baseColor.withAlphaComponent(0.0).cgColor,
        baseColor.withAlphaComponent(0.4).cgColor,
        baseColor.cgColor
    ]
    
    rulerGradientLayer.locations = [
        0.0,
        0.1963,
        0.4515,
        0.7961,
        1.0
    ] as [NSNumber]
    
    rulerGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    rulerGradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
}
```

---

## ⚙️ Configuration

| Property   | Description   | Default |
| ---------- | ------------- | ------- |
| `minValue` | Minimum value | `0`     |
| `maxValue` | Maximum value | `60`    |
| `step`     | Step interval | `1`     |

---

## 🔔 Callback

```swift
rulerView.onValueChange = { value in
    print(value)
}
```

---

## 🧠 How it works

* Uses a horizontal `UICollectionView`
* Each cell = 1 tick
* Center of screen = selected value
* Snaps to nearest tick on scroll end
* Converts scroll offset ↔ value

---

## 🎯 Customization Ideas

* Add labels (0, 5, 10…)
* Add infinite scrolling
* Add scaling effect near center
* Change tick height/spacing
* Add unit labels (sec/min)

---

## ⚠️ Notes

* Ensure `layoutIfNeeded()` is called before setting initial value if needed
* Gradient layer must be resized in `viewDidLayoutSubviews`
* Works best with consistent item width & spacing

---

## 📄 License

Free to use in personal and commercial projects.

---

## 🙌 Contribution

PRs and improvements are welcome!
