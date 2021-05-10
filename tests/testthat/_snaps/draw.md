# print_lastactual creates expected HTML

    Code
      print_lastactual(df)
    Output
      [1] "<p>Last actual United Kingdom: 2020<br>Last actual Austria: 2019</p>"

---

    Code
      print_lastactual(df)
    Output
      [1] "<p>Last actual United Kingdom: 2020<br>Last actual Austria: NA</p>"

---

    Code
      print_lastactual(df)
    Output
      [1] "<p>Last actual United Kingdom: NA<br>Last actual Austria: 2019</p>"

---

    Code
      print_lastactual(df)
    Output
      NULL

# print_note creates expected HTML

    Code
      print_note(df)
    Output
      [1] "<p>See notes for: xxx<br>See notes for: xxx</p>"

---

    Code
      print_note(df)
    Output
      [1] "<p>See notes for: xxx<br>NA</p>"

---

    Code
      print_note(df)
    Output
      [1] "<p>NA<br>See notes for: xxx</p>"

---

    Code
      print_note(df)
    Output
      NULL

