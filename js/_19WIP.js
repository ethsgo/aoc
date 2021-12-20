let input = `
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
`.trim()

if (!process.stdin.isTTY) {
  input = require('fs').readFileSync(0).toString().trim()
}

function parse(input) {
  const lines = input.split('\n')
  let scan = [[]]
  for (let i = 1; i < lines.length; i++) {
    if (lines[i].length == 0) {
      scan.push([])
      i++
    } else {
      scan[scan.length - 1].push(lines[i].split(',').map(Number))
    }
  }
  return scan
}

const permutations = (() => {
  let perm = []
  for (let xindex of [0, 1, 2]) {
    for (let yindex of [0, 1, 2]) {
      if (yindex === xindex) continue
      for (let zindex of [0, 1, 2]) {
        if (zindex === xindex) continue
        if (zindex === yindex) continue
        for (let nindex of [
          [],
          [0],
          [1],
          [2],
          [0, 1],
          [0, 2],
          [1, 2],
          [1, 2, 3],
        ]) {
          perm.push({
            x: { i: xindex, m: nindex.includes(xindex) ? -1 : 1 },
            y: { i: yindex, m: nindex.includes(yindex) ? -1 : 1 },
            z: { i: zindex, m: nindex.includes(zindex) ? -1 : 1 },
          })
        }
      }
    }
  }
  return perm
})()

const applyPermutation = (p, u) => [
  p.x.m * u[p.x.i],
  p.y.m * u[p.y.i],
  p.z.m * u[p.z.i],
]

const dist = (u, v) =>
  (u[0] - v[0]) ** 2 + (u[1] - v[1]) ** 2 + (u[2] - v[2]) ** 2

const equal = (u, v) => u[0] === v[0] && u[1] === v[1] && u[2] === v[2]
const add = (u, v) => [u[0] + v[0], u[1] + v[1], u[2] + v[2]]
const diff = (u, v) => [u[0] - v[0], u[1] - v[1], u[2] - v[2]]

const transform = (t, p) => add(applyPermutation(t.permutation, p), t.scanner)

const distancesFrom = (s, p) => new Map(s.map((q) => [dist(p, q), q]))
const intersection = (m1, m2) => [...m1.entries()].filter((e) => m2.has(e[0]))

const uniqCount = (points) => new Set(points.map(JSON.stringify)).size

function p1(scan) {
  function transformation(si1, si2) {
    for (let pi1 = 0; pi1 < scan[si1].length; pi1++) {
      // For the base scanner, consider each point as a reference point.
      // Find distances from that point in the coordinate space of this scan.
      const rp1 = scan[si1][pi1]
      const dm1 = distancesFrom(scan[si1], scan[si1][pi1])

      // For each other scan, find the reference point which has 12 of the same
      // distances from the other points in the coordinate space of that scan.
      for (let pi2 = 0; pi2 < scan[si2].length; pi2++) {
        const rp2 = scan[si2][pi2]
        const dm2 = distancesFrom(scan[si2], scan[si2][pi2])
        const ix = intersection(dm1, dm2)

        if (ix.length !== 12) continue

        let someCommonDistance = ix.find((e) => e[0] !== 0)[0]
        const d1 = diff(dm1.get(someCommonDistance), rp1)
        const d2 = diff(dm2.get(someCommonDistance), rp2)

        const pm = permutations.find((p) => equal(d1, applyPermutation(p, d2)))
        const sc = diff(rp1, applyPermutation(pm, rp2))
        return { scanner: sc, permutation: pm }
      }
    }
  }

  // Use scanner 0 as the reference coordinate space. Find the transformations
  // to tranform the other scanner's spaces into this reference space.
  let beacons = scan[0]

  let tmap = new Map()
  let newlyAdded = [0]

  while (newlyAdded.length > 0) {
    const i = newlyAdded.shift()
    // console.log(tmap)
    for (let j = 0; j < scan.length; j++) {
      if (i === j) continue
      if (tmap.has(i) && tmap.get(i).has(j)) continue
      if (tmap.has(j) && tmap.get(j).has(i)) continue
      const t = transformation(i, j)
      if (t) {
        // console.log(i, j)
        tmap.set(i, tmap.get(i) ?? new Map())
        tmap.get(i).set(j, t)
        newlyAdded.push(j)
      }
    }
  }

  for (let i = scan.length - 1; i > 0; i--) {
    let d = i
    let bx = [...scan[i]]
    while (d !== 0) {
      for (const [k, v] of tmap) {
        const t = v.get(d)
        if (t) {
          console.log(`${d} => ${k}`)
          bx = bx.map((p) => transform(t, p))
          d = k
        }
      }
    }
    beacons = [...beacons, ...bx]
    console.log('--')
  }
  /*
  const t01 = transformation(0, 1)
  for (const p of scan[1]) {
    beacons.push(transform(t01, p))
  }

  const t13 = transformation(1, 3)
  for (const p of scan[3]) {
    beacons.push(transform(t01, transform(t13, p)))
  }

  const t14 = transformation(1, 4)
  for (const p of scan[4]) {
    beacons.push(transform(t01, transform(t14, p)))
  }

  const t42 = transformation(4, 2)
  for (const p of scan[2]) {
    beacons.push(transform(t01, transform(t14, transform(t42, p))))
  }
*/
  return uniqCount(beacons)
}

const scan = parse(input)
console.log(p1(scan))
