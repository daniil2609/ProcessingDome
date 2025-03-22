void setupGUI() {
// Инициализация интерфейса ControlP5
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  // Слайдер детализации
  cp5.addSlider("detail")
    .setPosition(10, 10)
    .setSize(150, 20)
    .setRange(1, 8)
    .setValue(1);
    
  cp5.addTextfield("detail_text")
     .setPosition(10,35)
     .setSize(80, 20)
     .setFocus(false)
     .setColor(color(255,0,0))
     .setText(str((int)detail))
     .setAutoClear(false)
     .setLabel("") 
     ;
  
  // Слайдер отсечения
  cp5.addSlider("cutoff")
    .setPosition(10, 60)
    .setSize(150, 20)
    .setRange(-PI / 2, PI)
    .setValue(0);
         
  cp5.addTextfield("cutoff_text")
     .setPosition(10,85)
     .setSize(80, 20)
     .setFocus(false)
     .setColor(color(255,0,0))
     .setText(str((float)cutoff))
     .setAutoClear(false)
     .setLabel("") 
     ;
  
  // Слайдер радиуса
  cp5.addSlider("radius")
    .setPosition(10, 110)
    .setSize(150, 20)
    .setRange(10, 500)
    .setValue(100)
    ;

     
  cp5.addTextfield("radius_text")
     .setPosition(10,135)
     .setSize(80, 20)
     .setFocus(false)
     .setColor(color(255,0,0))
     .setText(str((float)radius))
     .setAutoClear(false)
     .setLabel("") 
     ;
  
  // Переключатель отображения только рёбер
  cp5.addToggle("showEdges")
    .setPosition(10, 165)
    .setSize(50, 20)
    .setValue(showEdges);
  
  // Переключатель ровных краёв
  cp5.addToggle("smoothEdges")
    .setPosition(90, 165)
    .setSize(50, 20)
    .setValue(smoothEdges);
    
  // Переключатель типа многогранника
  Group g1 = cp5.addGroup("g1")
    .setPosition(10,220)
    .setSize(150, 70)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(50)
    .setLabel("Toggle Polyhedron")
     ;
                
  cp5.addRadioButton("radio_g1")
     .setPosition(12,12)
     .setSize(20,15)
     .addItem("icosahedron",0)
     .addItem("octahedron",1)
     .setGroup(g1)
     .activate(polyhedronType.equals("icosahedron") ? 0 : 1)
     ;
     
  // Переключатель типа многогранника
  Group g2 = cp5.addGroup("g2")
    .setPosition(10,300)
    .setSize(150, 70)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(50)
    .setLabel("Method of detailing")
     ;
                
  cp5.addRadioButton("radio_g2")
     .setPosition(12,12)
     .setSize(20,15)
     .addItem("alternate",0)
     .addItem("triacon",1)
     .setGroup(g2)
     .activate(detailingType.equals("alternate") ? 0 : 1)
     ;
     
  // кнопка сохранения obj
  cp5.addButton("saveOBJ")
     .setValue(0)
     .setPosition(10,375)
     .setSize(70,25)
     .setLabel("save OBJ")
     .onClick(new CallbackListener() {
     public void controlEvent(CallbackEvent event) {
        exportToOBJ("outputDome");
       }
     });
 
  // кнопка загрузки obj
  cp5.addButton("loadOBJ")
     .setValue(0)
     .setPosition(90,375)
     .setSize(70,25)
     .setLabel("load OBJ")
     .onClick(new CallbackListener() {
     public void controlEvent(CallbackEvent event) {
        selectInput("Выберите .obj файл:", "fileSelected"); // Открываем окно выбора файла при старте
       }
     });
     
     // кнопка сохранения x
  cp5.addButton("saveX")
     .setValue(0)
     .setPosition(10,405)
     .setSize(70,25)
     .setLabel("save X")
     .onClick(new CallbackListener() {
     public void controlEvent(CallbackEvent event) {
        exportToX("outputDome");
       }
     });
     
  //слайдер изменения цвета
  cp5.addSlider("color")
    .setPosition(10, 600)
    .setSize(150, 20)
    .setRange(0, 255)
    .setValue(150);
    
  //слайдер изменения прозрачности
  cp5.addSlider("alpha")
    .setPosition(10, 625)
    .setSize(150, 20)
    .setRange(0, 255)
    .setValue(150);
    
      //слайдер изменения прозрачности граней
  cp5.addSlider("stroke")
    .setPosition(10, 650)
    .setSize(150, 20)
    .setRange(0, 255)
    .setValue(150);
}


// Обработка изменений параметров
void controlEvent(ControlEvent event) {
  if (event.isFrom("detail") || event.isFrom("cutoff") || event.isFrom("radius")) {
    detail = (int)cp5.getController("detail").getValue();
    cutoff = cp5.getController("cutoff").getValue();
    radius = cp5.getController("radius").getValue();
    cp5.get(Textfield.class, "detail_text").setText(str((int)detail));
    cp5.get(Textfield.class, "cutoff_text").setText(str((float)cutoff));
    cp5.get(Textfield.class, "radius_text").setText(str((float)radius));
    createDome();
  }
  if (event.isFrom("showEdges") || event.isFrom("smoothEdges")) {
    showEdges = cp5.getController("showEdges").getValue() == 1;
    smoothEdges = cp5.getController("smoothEdges").getValue() == 1;
  }
  if(event.isFrom("radio_g1")) {
    polyhedronType = event.getValue() == 1.0 ? "octahedron" : "icosahedron";
    createDome();
  }
   if(event.isFrom("radio_g2")) {
    detailingType = event.getValue() == 1.0 ? "triacon" : "alternate";
    createDome();
  }
   if (event.isFrom(cp5.get(Textfield.class, "detail_text")) || event.isFrom(cp5.get(Textfield.class, "cutoff_text")) || event.isFrom(cp5.get(Textfield.class, "radius_text"))) {
        try {
          int newdetail = Integer.parseInt(cp5.get(Textfield.class, "detail_text").getText());
          float newcutoff = Float.parseFloat(cp5.get(Textfield.class, "cutoff_text").getText());
          float newradius = Float.parseFloat(cp5.get(Textfield.class, "radius_text").getText());
          
          cp5.getController("detail").setValue(newdetail);
          cp5.getController("cutoff").setValue(newcutoff);
          cp5.getController("radius").setValue(newradius);
          
          cp5.get(Textfield.class, "detail_text").setFocus(false);
          cp5.get(Textfield.class, "cutoff_text").setFocus(false);
          cp5.get(Textfield.class, "radius_text").setFocus(false);

        } catch (NumberFormatException e) {
          cp5.get(Textfield.class, "detail_text").setFocus(false);
          cp5.get(Textfield.class, "cutoff_text").setFocus(false);
          cp5.get(Textfield.class, "radius_text").setFocus(false);
          
          cp5.get(Textfield.class, "detail_text").setValue(str(detail));
          cp5.get(Textfield.class, "cutoff_text").setValue(str(cutoff));
          cp5.get(Textfield.class, "radius_text").setValue(str(radius));
        }
      }
      
   if (event.isFrom("color") || event.isFrom("alpha") || event.isFrom("stroke")) {
    colorDome = (int)cp5.getController("color").getValue();
    transparencyDome = (int)cp5.getController("alpha").getValue();
    transparencyDomeStroke = (int)cp5.getController("stroke").getValue();
    createDome();
}
}


void drawHUD() {
  // Сохраняем текущую матрицу преобразований
  pushMatrix();
  
  // Сбрасываем все преобразования (включая камеру)
  resetMatrix();
  
  // Устанавливаем 2D-режим для отрисовки текста
  hint(DISABLE_DEPTH_TEST); // Отключаем тест глубины для текста
  cam.beginHUD();
  
    // Рисуем фон для левой части окна
  fill(60); // Серый цвет фона
  noStroke(); // Убираем обводку
  rect(0, 0, 200, 768); // Прямоугольник на всю левую часть окна
  
  fill(255); // Цвет текста
  textSize(14); // Размер текста
  String infoText = "FPS: " + (int)frameRate + "\n" +
                  "Метод разбивки: " + (detailingType.equals("alternate") ? "Alternate" : "Triacon") + "\n" +
                  "Базовый многогранник: " + (polyhedronType.equals("icosahedron") ? "Icosahedron" : "Octahedron") + "\n" +
                  "Количество треугольников: " + countTriangles + "\n" +
                  "Частота детализации: " + frequency + "\n" +
                  "Обрезка: " + cutoff + "\n" +
                  "Радиус: " + radius + "\n" +
                  "Только грани: " + (showEdges ? "да" : "нет") + "\n" +
                  "Дополнять до плоскости: " + (smoothEdges ? "да" : "нет");

  text(infoText, 750, 10, 274, 384);
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST); // Включаем тест глубины обратно
  
  // Восстанавливаем матрицу преобразований
  popMatrix();
}

void draw3DScene() {
  pushMatrix();  // Сохраняем текущую систему координат
  translate(612, 384, 0);  // Перемещаем сцену в центр
  background(50);  // Устанавливаем фоновый цвет
  lights();  // Включаем освещение
  
  drawDome();  // Рисуем купол (Triangle.pde)
  
  popMatrix();  // Восстанавливаем систему координат
}
