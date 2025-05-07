ArrayList<Triangle> domeTriangles = new ArrayList<Triangle>(); // Массив для хранения всех треугольников купола

class Triangle {
  PVector v1, v2, v3; // Вершины треугольника

  // Конструктор
  Triangle(PVector v1, PVector v2, PVector v3) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }

  // Метод для отображения треугольника
  void display() {
    if (showEdges) {
      stroke(transparencyDomeStroke);
      noFill();
      beginShape(TRIANGLES);
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
      vertex(v3.x, v3.y, v3.z);
      endShape(CLOSE);
    } else {
      stroke(transparencyDomeStroke);
      int[] colors = getColorDome();
      fill(colors[0], colors[1], colors[2], transparencyDome);
      beginShape(TRIANGLES);
      vertex(v1.x, v1.y, v1.z);
      vertex(v2.x, v2.y, v2.z);
      vertex(v3.x, v3.y, v3.z);
      endShape(CLOSE);
    }
  }

  // Метод для обрезки треугольника по заданной плоскости отсечения
  // Возвращает список новых треугольников, полученных после обрезки
  ArrayList<Triangle> cut(float cutoffZ, float cutoffAngleZ, float cutoffAngleX, float cutoffAngleY) {
      // Списки для хранения вершин:
      // above - вершины выше плоскости отсечения (должны остаться)
      // below - вершины ниже плоскости отсечения (будут обрезаны)
      ArrayList<PVector> above = new ArrayList<PVector>();
      ArrayList<PVector> below = new ArrayList<PVector>();
  
      // Классифицируем каждую вершину треугольника (v1, v2, v3):
      // проверяем, находится ли она выше или ниже плоскости отсечения
      for (PVector v : new PVector[]{v1, v2, v3}) {
          if (isVertexBelow(v, cutoffZ, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
              above.add(v);  // Вершина выше плоскости - сохраняем
          } else {
              below.add(v);  // Вершина ниже плоскости - будем обрезать
          }
      }
  
      ArrayList<Triangle> result = new ArrayList<Triangle>();  // Результирующие треугольники
  
      // Случай 1: Все три вершины выше плоскости отсечения
      // Сохраняем исходный треугольник без изменений
      if (above.size() == 3) {
          result.add(this);
      } 
      // Случай 2: Две вершины выше, одна ниже плоскости
      // Создаем два новых треугольника, заменяя обрезанную часть
      else if (above.size() == 2 && below.size() == 1) {
          // Находим точки пересечения плоскости с ребрами треугольника
          PVector p1 = getIntersection(below.get(0), above.get(0), cutoffZ, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
          PVector p2 = getIntersection(below.get(0), above.get(1), cutoffZ, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
          
          // Формируем два новых треугольника:
          // 1. Из двух оставшихся вершин и первой точки пересечения
          result.add(new Triangle(above.get(0), above.get(1), p1));
          // 2. Из второй оставшейся вершины и обеих точек пересечения
          result.add(new Triangle(above.get(1), p1, p2));
      } 
      // Случай 3: Одна вершина выше, две ниже плоскости
      // Создаем один новый треугольник из оставшейся вершины и точек пересечения
      else if (above.size() == 1 && below.size() == 2) {
          // Находим точки пересечения плоскости с ребрами треугольника
          PVector p1 = getIntersection(above.get(0), below.get(0), cutoffZ, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
          PVector p2 = getIntersection(above.get(0), below.get(1), cutoffZ, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
          
          // Формируем новый треугольник из оставшейся вершины и точек пересечения
          result.add(new Triangle(above.get(0), p1, p2));
      }
      
      return result;  // Возвращаем все полученные треугольники
  }
  
  // Метод проверки, находится ли вершина ниже плоскости отсечения
  // Возвращает true, если вершина ниже или на плоскости, false - если выше
  boolean isVertexBelow(PVector v, float cutoffZ, float cutoffAngleZ, float cutoffAngleX, float cutoffAngleY) {
      // Поворачиваем вершину в соответствии с углами плоскости отсечения
      PVector rotated = rotatePointForCalculation(v, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
      // Сравниваем Z-координату с граничным значением
      return rotated.z <= cutoffZ;
  }
  
  // Метод поиска точки пересечения ребра треугольника с плоскостью отсечения
  // Возвращает точку пересечения в исходных координатах
  PVector getIntersection(PVector start, PVector end, float cutoffZ, 
                         float cutoffAngleZ, float cutoffAngleX, float cutoffAngleY) {
      // Поворачиваем обе точки ребра в соответствии с углами плоскости
      PVector rotStart = rotatePointForCalculation(start, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
      PVector rotEnd = rotatePointForCalculation(end, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
      
      // Вычисляем параметр t для линейной интерполяции между точками
      // t = 0 соответствует точке start, t = 1 - точке end
      float t = (cutoffZ - rotStart.z) / (rotEnd.z - rotStart.z);
      
      // Возвращаем точку пересечения в исходной системе координат
      return PVector.add(start, PVector.sub(end, start).mult(t));
  }

  // Отображение плоскости отсечения
  void displayCuttingPlane(float cutoffZ, float cutoffAngleZ, float cutoffAngleX, float cutoffAngleY) {
    pushMatrix();
    pushStyle();
    
    // Применяем повороты
    rotateZ(-cutoffAngleZ);
    rotateX(-cutoffAngleX);
    rotateY(-cutoffAngleY);
    
    // Настройки цвета
    int[] colors = getColorDome();
    fill(colors[0], colors[1], colors[2], transparencyDome/2);
    noStroke();
    
    //Рисуем основную плоскость (двустороннюю)
    float planeSize = radius*2;
    beginShape(QUADS);
    // Лицевая сторона
    vertex(-planeSize, -planeSize, cutoffZ);
    vertex(planeSize, -planeSize, cutoffZ);
    vertex(planeSize, planeSize, cutoffZ);
    vertex(-planeSize, planeSize, cutoffZ);
    endShape();
    
    //Рисуем сетку
    stroke(255, 100); // Полупрозрачный белый
    strokeWeight(0.8);
    float gridStep = radius/5;
    
    //Вертикальные линии сетки
    for(float x = -planeSize; x <= planeSize; x += gridStep) {
        line(x, -planeSize, cutoffZ, x, planeSize, cutoffZ);
    }
    
    //Горизонтальные линии сетки
    for(float y = -planeSize; y <= planeSize; y += gridStep) {
        line(-planeSize, y, cutoffZ, planeSize, y, cutoffZ);
    }
    
    //Рисуем нормаль по обе стороны плоскости (белую)
    stroke(255, 100); // Полупрозрачный белый
    strokeWeight(2);
    
    // Нормаль в положительном направлении (на весь экран)
    PVector normEndPos = new PVector(0, 0, planeSize*100);
    line(0, 0, 0, normEndPos.x, normEndPos.y, normEndPos.z);
    
    // Нормаль в отрицательном направлении (на весь экран)
    PVector normEndNeg = new PVector(0, 0, -planeSize*100);
    line(0, 0, 0, normEndNeg.x, normEndNeg.y, normEndNeg.z);
    
    popStyle();
    popMatrix();
  }

  // Поворот точки для расчетов (порядок Z -> X -> Y)
  private PVector rotatePointForCalculation(PVector v, float angleZ, float angleX, float angleY) {
    PVector rotated = v.copy();
    
    // Поворот вокруг Z
    float x = rotated.x * cos(angleZ) - rotated.y * sin(angleZ);
    float y = rotated.x * sin(angleZ) + rotated.y * cos(angleZ);
    rotated.set(x, y, rotated.z);
    
    // Поворот вокруг X
    y = rotated.y * cos(angleX) - rotated.z * sin(angleX);
    float z = rotated.y * sin(angleX) + rotated.z * cos(angleX);
    rotated.set(rotated.x, y, z);
    
    // Поворот вокруг Y
    x = rotated.x * cos(angleY) + rotated.z * sin(angleY);
    z = -rotated.x * sin(angleY) + rotated.z * cos(angleY);
    rotated.set(x, rotated.y, z);
    
    return rotated;
  }
}

// Метод для создания купола
void createDome() {
  domeTriangles.clear(); // Очищаем массив перед созданием нового купола

  PVector[] baseVertices; // Вершины базового многогранника
  int[][] faces; // Стороны многогранника (массив индексов вершин)

  // Определяем вершины и стороны в зависимости от типа многогранника
  if (polyhedronType.equals("icosahedron")) {
    baseVertices = generateIcosahedronVertices(); // Вершины икосаэдра
    faces = generateIcosahedronFaces(); // Стороны икосаэдра
  } else {
    baseVertices = generateOctahedronVertices(); // Вершины октаэдра
    faces = generateOctahedronFaces(); // Стороны октаэдра
  }

  // Проходим по каждой стороне многогранника
  for (int[] face : faces) {
    // Получаем вершины стороны и нормализуем их, чтобы они лежали на сфере
    PVector v1 = baseVertices[face[0]].copy().normalize().mult(radius);
    PVector v2 = baseVertices[face[1]].copy().normalize().mult(radius);
    PVector v3 = baseVertices[face[2]].copy().normalize().mult(radius);
    if (detailingType.equals("recursionMethod")){
      frequency = detail; //для вывода частоты детализации
      subdivideRecursionMethod(v1, v2, v3, detail);
    }else{
      subdivideAlternate(v1, v2, v3, detail);
    }
    
  }
}

// Основной метод для отображения купола
void drawDome() {
  int counter = 0; // Счетчик отображаемых треугольников
  
  // Отображаем плоскость отсечения, если нужно:
  // Проверяем, есть ли треугольники в куполе и включена ли опция показа плоскости
  if (domeTriangles.size() > 0) {
    if (showCuttingPlane){
      //Визуализируем плоскость отсечения
      domeTriangles.get(0).displayCuttingPlane(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
    }
  }
  
  // Проходим по всем треугольникам купола
  for (Triangle t : domeTriangles) {
    // Если дополнение до плоскости включено
    if (smoothEdges) {
      ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
      // Отображаем каждый полученный треугольник
      for (Triangle ct : cutTriangles) {
        counter++; // Увеличиваем счетчик
        ct.display(); // Отображаем треугольник
      }
    } 
    // Если дополнение до плоскости отключено (оптимизированный режим)
    else {
      // Проверяем, все ли вершины треугольника находятся НИЖЕ плоскости отсечения:
      if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
          t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
          t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
        counter++; // Увеличиваем счетчик
        t.display(); // Отображаем треугольник
      }
    }
  }
  // Сохраняем общее количество отображенных треугольников
  countTriangles = counter;
}

// Метод рекурсивного деления треугольника на более мелкие, для увеличения детализации геодезического купола
void subdivideRecursionMethod(PVector v1, PVector v2, PVector v3, int depth) {
    // Условие завершения рекурсии: если глубина деления <= 1, сохраняем текущий треугольник без дальнейшего деления
    if (depth <= 1) {
        domeTriangles.add(new Triangle(v1, v2, v3));  // Добавляем треугольник в список для отрисовки
        return; // Прерываем выполнение функции, не углубляемся дальше
    }

    // Вычисляем новые точки на серединах сторон треугольника
    // Складываем пары вершин и нормализуем вектор, чтобы он находился на поверхности сферы (радиус = 1), затем масштабируем до текущего радиуса
    PVector v12 = PVector.add(v1, v2).normalize().mult(radius); // середина между v1 и v2
    PVector v23 = PVector.add(v2, v3).normalize().mult(radius); // середина между v2 и v3
    PVector v31 = PVector.add(v3, v1).normalize().mult(radius); // середина между v3 и v1

    // Делим исходный треугольник на 4 меньших треугольника и продолжаем рекурсию для каждого
    subdivideAlternate(v1, v12, v31, depth);     // верхний левый
    subdivideAlternate(v2, v23, v12, depth);     // нижний правый
    subdivideAlternate(v3, v31, v23, depth);     // нижний левый
    subdivideAlternate(v12, v23, v31, depth);    // центральный треугольник
}

// Метод альтернативного деления треугольника: создает сетку точек внутри треугольника и строит из них мелкие треугольники
void subdivideAlternate(PVector v1, PVector v2, PVector v3, int depth) {
  frequency = depth; // Устанавливаем частоту (количество делений сторон треугольника)

  // Создаем двумерный массив точек (вершин) сетки треугольника
  PVector[][] grid = new PVector[frequency + 1][frequency + 1];

  // Генерируем координаты всех точек сетки внутри треугольника
  for (int i = 0; i <= frequency; i++) {
    for (int j = 0; j <= i; j++) {
      // Коэффициенты барицентрических координат: сумма a + b + c = 1
      float a = (float)(i - j) / frequency;
      float b = (float)j / frequency;
      float c = 1.0 - a - b;

      // Вычисляем координаты точки как взвешенную сумму трех вершин треугольника
      PVector p = PVector.add(PVector.mult(v1, a), PVector.mult(v2, b)); // сначала a*v1 + b*v2
      p.add(PVector.mult(v3, c)); // затем прибавляем c*v3

      // Нормализуем точку, чтобы она находилась на сфере, и масштабируем до радиуса сферы
      p.normalize();
      p.mult(radius);

      // Сохраняем точку в сетке
      grid[i][j] = p;
    }
  }

  // Строим мелкие треугольники из полученных точек сетки
  for (int i = 0; i < frequency; i++) {
    for (int j = 0; j <= i; j++) {
      // Первый треугольник (нижний)
      domeTriangles.add(new Triangle(grid[i][j], grid[i+1][j], grid[i+1][j+1]));
      
      // Второй треугольник (верхний), только если не на диагонали
      if (j < i) domeTriangles.add(new Triangle(grid[i][j], grid[i+1][j+1], grid[i][j+1]));
    }
  }
}

// Метод для генерации вершин икосаэдра
PVector[] generateIcosahedronVertices() {
  float phi = (1 + sqrt(5)) / 2; // Число золотого сечения
  // Возвращаем массив вершин икосаэдра
  return new PVector[] {
    new PVector(-1, phi, 0), new PVector(1, phi, 0), new PVector(-1, -phi, 0), new PVector(1, -phi, 0),
    new PVector(0, -1, phi), new PVector(0, 1, phi), new PVector(0, -1, -phi), new PVector(0, 1, -phi),
    new PVector(phi, 0, -1), new PVector(phi, 0, 1), new PVector(-phi, 0, -1), new PVector(-phi, 0, 1)
  };
}

// Метод для генерации сторон икосаэдра (список индексов вершин)
int[][] generateIcosahedronFaces() {
  return new int[][] {
    {0, 11, 5}, {0, 5, 1}, {0, 1, 7}, {0, 7, 10}, {0, 10, 11},
    {1, 5, 9}, {5, 11, 4}, {11, 10, 2}, {10, 7, 6}, {7, 1, 8},
    {3, 9, 4}, {3, 4, 2}, {3, 2, 6}, {3, 6, 8}, {3, 8, 9},
    {4, 9, 5}, {2, 4, 11}, {6, 2, 10}, {8, 6, 7}, {9, 8, 1}
  };
}

// Метод для генерации вершин октаэдра
PVector[] generateOctahedronVertices() {
  return new PVector[] {
    new PVector(1, 0, 0), new PVector(-1, 0, 0), new PVector(0, 1, 0),
    new PVector(0, -1, 0), new PVector(0, 0, 1), new PVector(0, 0, -1)
  };
}

// Метод для генерации сторон октаэдра (список индексов вершин)
int[][] generateOctahedronFaces() {
  return new int[][] {
    {0, 2, 4}, {2, 1, 4}, {1, 3, 4}, {3, 0, 4},
    {0, 5, 2}, {2, 5, 1}, {1, 5, 3}, {3, 5, 0}
  };
}
