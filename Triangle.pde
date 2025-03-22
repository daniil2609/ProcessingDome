ArrayList<Triangle> domeTriangles = new ArrayList<Triangle>(); // Массив для хранения всех треугольников купола

class Triangle {
  PVector v1, v2, v3; // Вершины треугольника

  // Конструктор для инициализации вершин треугольника
  Triangle(PVector v1, PVector v2, PVector v3) {
    this.v1 = v1;
    this.v2 = v2;
    this.v3 = v3;
  }

  // Метод для отображения треугольника
  void display() {
    if (showEdges) {
      stroke(transparencyDomeStroke);
      noFill(); // Заполнение выключено
      beginShape(TRIANGLES); // Начинаем рисовать ребра треугольника
      vertex(v1.x, v1.y, v1.z); // Первая вершина
      vertex(v2.x, v2.y, v2.z); // Вторая вершина
      vertex(v3.x, v3.y, v3.z); // Третья вершина
      endShape(CLOSE); // Закрываем контур треугольника
    } else {
      stroke(transparencyDomeStroke);
        // Получаем цвета
      int[] colors = getColorDome(); //(Utils.pde)
      int r = colors[0];
      int g = colors[1];
      int b = colors[2];
      fill(r, g, b, transparencyDome);
      beginShape(TRIANGLES); // Начинаем отрисовку треугольника
      vertex(v1.x, v1.y, v1.z); // Первая вершина
      vertex(v2.x, v2.y, v2.z); // Вторая вершина
      vertex(v3.x, v3.y, v3.z); // Третья вершина
      endShape(CLOSE); // Завершаем отрисовку треугольника
    }
  }
   // Метод для обрезки треугольника
  ArrayList<Triangle> cut(float cutoffZ) {
    cutoffZ = cutoffZ - 0.00001;
    ArrayList<PVector> above = new ArrayList<PVector>();
    ArrayList<PVector> below = new ArrayList<PVector>();

    // Проверяем, какие вершины находятся выше и ниже плоскости отсечения
    for (PVector v : new PVector[]{v1, v2, v3}) {
      if (v.z <= cutoffZ) above.add(v);
      else below.add(v);
    }

    ArrayList<Triangle> result = new ArrayList<Triangle>();

    if (above.size() == 3) {
      // Все вершины выше плоскости - добавляем весь треугольник
      result.add(this);
    } else if (above.size() == 2 && below.size() == 1) {
      // Две вершины выше плоскости - создаем один треугольник
      PVector p1 = getIntersection(below.get(0), above.get(0), cutoffZ);
      PVector p2 = getIntersection(below.get(0), above.get(1), cutoffZ);
      result.add(new Triangle(above.get(0), above.get(1), p1));
      result.add(new Triangle(above.get(1), p1, p2));
    } else if (above.size() == 1 && below.size() == 2) {
      // Одна вершина выше плоскости - создаем один треугольник
      PVector p1 = getIntersection(above.get(0), below.get(0), cutoffZ);
      PVector p2 = getIntersection(above.get(0), below.get(1), cutoffZ);
      result.add(new Triangle(above.get(0), p1, p2));
    }
    return result;
  }

  // Находим точку пересечения ребра с плоскостью отсечения
  PVector getIntersection(PVector start, PVector end, float cutoffZ) {
    float t = (cutoffZ - start.z) / (end.z - start.z);
    return PVector.add(start, PVector.sub(end, start).mult(t));
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
    if (detailingType.equals("alternate")){
      frequency = detail; //для вывода частоты детализации
      subdivideAlternate(v1, v2, v3, detail);
    }else{
      subdivideTriacon(v1, v2, v3, detail);
    }
    
  }
}

// Метод для отображения купола (с ровной поверхностью)
void drawDome() {
  // Проходим по каждому треугольнику в куполе
  int counter = 0;
  for (Triangle t : domeTriangles) {
    if(smoothEdges){
      ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius);
      for (Triangle ct : cutTriangles) {
        counter++;
        ct.display(); // отображаем каждый обрезанный треугольник
      }
      countTriangles = counter;
    } // Метод для отображения купола (с рваной поверхностью)
    else{
      if (t.v1.z < cutoff * radius && t.v2.z < cutoff * radius && t.v3.z < cutoff * radius) {
        counter++;
        t.display(); // Отображаем треугольник, если он находится ниже уровня отсечения
      }
      countTriangles = counter;
    }
  }
}

// Методы для деления треугольника для увеличения детализации
void subdivideAlternate(PVector v1, PVector v2, PVector v3, int depth) {
    if (depth <= 1) {  // Останавливаем рекурсию при depth == 1
        domeTriangles.add(new Triangle(v1, v2, v3));
        return;
    }

    PVector v12 = PVector.add(v1, v2).normalize().mult(radius);
    PVector v23 = PVector.add(v2, v3).normalize().mult(radius);
    PVector v31 = PVector.add(v3, v1).normalize().mult(radius);

    // Если depth нечётное, уменьшаем на 1 перед передачей в рекурсию
    int newDepth = (depth % 2 == 0) ? depth - 1 : depth - 1;

    // Рекурсивно делим треугольник
    subdivideAlternate(v1, v12, v31, newDepth);
    subdivideAlternate(v2, v23, v12, newDepth);
    subdivideAlternate(v3, v31, v23, newDepth);
    subdivideAlternate(v12, v23, v31, newDepth);
}

void subdivideTriacon(PVector v1, PVector v2, PVector v3, int depth) {
    switch (depth) {
    case 1:
      frequency = 1;
      break;
    case 2:
      frequency = 2;
      break;
    case 3:
      frequency = 4;
      break;
    case 4:
      frequency = 6;
      break;
    case 5:
      frequency = 8;
      break;
    case 6:
      frequency = 10;
      break;
    case 7:
      frequency = 12;
      break;
    case 8:
      frequency = 14;
      break;
    default:
      frequency = 1;
      break;
  }
  
  PVector[][] grid = new PVector[frequency + 1][frequency + 1];
  
  for (int i = 0; i <= frequency; i++) {
    for (int j = 0; j <= i; j++) {
      float a = (float)(i - j) / frequency;
      float b = (float)j / frequency;
      float c = 1.0 - a - b;
      PVector p = PVector.add(PVector.mult(v1, a), PVector.mult(v2, b));
      p.add(PVector.mult(v3, c));
      p.normalize();
      p.mult(radius);
      grid[i][j] = p;
    }
  }
  
  for (int i = 0; i < frequency; i++) {
    for (int j = 0; j <= i; j++) {
      domeTriangles.add(new Triangle(grid[i][j], grid[i+1][j], grid[i+1][j+1]));
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
