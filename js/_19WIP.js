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

// TODO: Clean
const assert = require('assert')

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

function dist(p1, p2) {
  // return p1[0] - p2[0] + (p1[1] - p2[1]) + (p1[2] - p2[2])
  return (p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2 + (p1[2] - p2[2]) ** 2
}

function p1(scan) {
  function distancesFrom(si, pi) {
    const s = scan[si]
    // reference point
    const rp = s[pi]
    let m = new Map()
    for (let i = 0; i < s.length; i++) {
      if (true || i !== pi) {
        assert(!m.get(dist(s[i], rp)))
        m.set(dist(s[i], rp), s[i])
      }
    }
    return m
  }

  const intersection = (m1, m2) => [...m1.entries()].filter((e) => m2.has(e[0]))

  /// Return the coordinate of scanner si2 in the coordinate space of scanner si1.
  function scannerCoord(si1, si2) {
    // For each scan, consider one of the points as the reference point.
    for (let pi1 = 0; pi1 < scan[si1].length; pi1++) {
      // console.log({ checking: si2, pi1 })

      // Find distances from that point in the coordinate space of this scan.
      let m1 = distancesFrom(si1, pi1)

      // For each other scan, find the reference point which has 12 of the same
      // distances from the other points in the coordinate space of that scan.

      for (let pi2 = 0; pi2 < scan[si2].length; pi2++) {
        const m2 = distancesFrom(si2, pi2)
        const ix = intersection(m1, m2)
        // console.log({ checking: si2, pi1, pi2, ixc: ix.length })

        // console.log(ix.length)

        if (ix.length !== 12) continue

        const rp1 = scan[si1][pi1]
        const rp2 = scan[si2][pi2]
        // console.log({ match: true, si1, pi1, rp1, si2, pi2, rp2 })
        console.log({ match: true, si1, pi1, si2, pi2 })

        // So both the reference points refer to the same beacon.

        // console.log(rp1[0] - rp2[0], rp1[1] - rp2[1], rp1[2] - rp2[2])
        // console.log(rp1[0] + rp2[0], rp1[1] + rp2[1], rp1[2] + rp2[2])
        // console.log(m1)
        // console.log(m2)

        // // Combine all points at the same distances
        // let mc = new Map()
        // for (const [k, v] of m1) {
        //   mc.set(k, [...(mc.get(k) ?? []), v])
        // }
        // for (const [k, v] of m2) {
        //   mc.set(k, [...(mc.get(k) ?? []), v])
        // }
        // console.log(mc)
        // Combine all points at the same distances
        let mc = new Map()
        for (const [k] of ix) {
          mc.set(k, [m1.get(k), m2.get(k)])
        }
        console.log('common', mc)

        const equal = (u, v) => u[0] === v[0] && u[1] === v[1] && u[2] === v[2]

        const sl = (u, v, d) => [
          (u[0] - v[0]) / d,
          (u[1] - v[1]) / d,
          (u[2] - v[2]) / d,
        ]

        // console.log('slopes of 1')
        for (const [k, v] of m1) {
          if (equal(v, rp1)) continue
          console.log(sl(v, rp1, Math.sqrt(k)), 1)
        }

        // console.log('slopes of 2')
        for (const [k, v] of m2) {
          if (equal(v, rp2)) continue
          console.log(sl(v, rp2, Math.sqrt(k)), 2)
        }

        return
        // const add = (u, v) => [u[0] + v[0], u[1] + v[1], u[2] + v[2]]

        // for (const [k, v] of mc) {
        //   console.log(add(v[0], v[1]))
        // }
        // prettier-ignore
        const tx = [
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, +1], [+1, +1], [+1, -1]],
          [[+1, +1], [+1, +1], [-1, +1]],
          [[+1, +1], [+1, +1], [-1, -1]],
  
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, +1], [+1, -1], [+1, +1]],
          [[+1, +1], [-1, +1], [+1, +1]],
          [[+1, +1], [-1, -1], [+1, +1]],
  
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, +1], [+1, -1], [+1, -1]],
          [[+1, +1], [-1, +1], [-1, +1]],
          [[+1, +1], [-1, -1], [-1, -1]],
  
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, -1], [+1, +1], [+1, +1]],
          [[-1, +1], [+1, +1], [+1, +1]],
          [[-1, -1], [+1, +1], [+1, +1]],
  
          [[-1, -1], [+1, +1], [-1, -1]],
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, -1], [+1, +1], [+1, -1]],
          [[-1, +1], [+1, +1], [-1, +1]],
  
          [[-1, -1], [-1, -1], [-1, -1]],
          [[+1, +1], [+1, +1], [+1, +1]],
          [[+1, -1], [+1, -1], [+1, -1]],
          [[-1, +1], [-1, +1], [-1, +1]],
        ]

        // console.log(tx.length)

        const addtx = (u, v, t) => [
          t[0][0] * u[0] + t[0][1] * v[0],
          t[1][0] * u[1] + t[1][1] * v[1],
          t[2][0] * u[2] + t[2][1] * v[2],
        ]

        const diff = (u, v) => [u[0] - v[0], u[1] - v[1], u[2] - v[2]]
        const slope = (s1, s2) => [
          (s1[0][0] - s2[0][0]) / (s1[1][0] - s2[1][0]),
          (s1[0][1] - s2[0][1]) / (s1[1][1] - s2[1][1]),
          (s1[0][2] - s2[0][2]) / (s1[1][2] - s2[1][2]),
        ]

        // Find the transformation that causes the same delta between the
        // different representations of two different beacons. This
        // transformation is the coordinate of this scanner in the coordinate
        // space of the original scanner.
        function matchingOffset(same1, same2) {
          // for (let i = 0; i < tx.length; i++) {
          const d1 = addtx(same1[0], same1[1], tx[i])
          const d2 = addtx(same2[0], same2[1], tx[i])
          // Relative to s0
          // prettier-ignore
          // const d0 = addtx([ 68, -1246, -43 ], same1[1], [[-1, -1], [-1, +1], [-1, -1]])
          console.log(d1, d2, slope(same1, same2)) //, d0)
          // if (equal(d1, d2)) return { d: d1, t: tx[i] }
          // }
        }

        const mv = [...mc.values()]
        // console.log(mv)
        for (let a = 0; a < mv.length; a++) {
          for (let b = a + 1; b < mv.length; b++) {
            // const kp = [
            //   [-391, 539, -444],
            //   [-660, -479, -426],
            // ]
            // console.log(a, b)
            console.log(slope(mv[a], mv[b]))
            // console.log(mv[0], matchingOffset(mv[0], kp))
          }
        }
        return

        let [same1, same2, same3] = mc.values()
        let mo = matchingOffset(same1, same2)
        console.log(mo)
        // if (!mo) {
        //   console.log('skip')
        //   mo = matchingOffset(same1, same3)
        //   console.log(mo)
        // }
        if (!mo) return
        let offset = mo.d

        console.log({ scannerCoordinate: offset, si1, si2, transform: mo.t })
        return offset

        console.log({ scanner: si2, coordinate: offset })

        const invertT = (t) => t.map((w) => [w[0], -w[1]])

        for (const pt2 of m2.values()) {
          // for (let i = 0; i < tx.length; i++) {
          //   console.log(pt2, addtx(offset, pt2, tx[i]), tx[i])
          // }
          // This point in the reference coordinate space.
          let pt1 = addtx(offset, pt2, invertT(mo.t))
          // Add to the set of known beacons
          beacons.set(refDist(pt1), pt1)

          // console.log(pt2, addtx(pt2, offset, mo.t))
        }

        console.log('#b', beacons.size)
        // return
        // break next_scanner
        pi1 = scan[si1].length
        break
      }
    }
  }

  // const intersection = (s1, s2) => [...s1].filter((v) => s2.has(v))

  // Consider the coordinate system of the first scanner as the reference space.
  // Index the beacons in this space by their distance to the coordinates of
  // the first beacon
  // let beacons = distancesFrom(0, 0)
  // console.log('#b', beacons.size)

  const refDist = (pt) => dist(pt, scan[0][0])

  // { scannerCoordinate: [ 68, -1246, -43 ], si1: 0, si2: 1 }
  // scannerCoord(0, 1)

  // { scannerCoordinate: [ 160, -1134, -23 ], si1: 1, si2: 3 }
  // scannerCoord(1, 3)

  // for (let i = 0; i <= 4; i++) for (let j = 0; j <= 4; j++) scannerCoord(i, j)

  scannerCoord(1, 4)

  return
  // for (let si1 = 0; si1 < scan.length; si1++) {
  //   for (let si2 = si1 + 1; si2 < scan.length; si2++) {
  //     console.log(scannerCoord(si1, si2))
  //     // return
  //   }
  // }

  // let bs = [...beacons.values()].sort((u, v) => u[0] - v[0])
  // console.log('#b', beacons.size)
  // console.log(bs)

  return
  // for (let pi1 = 0; pi1 < scan[0].length; pi1++) {
  // Find distances from a point in the first scan
  let m1 = distancesFrom(3, 0)

  // for (let i = 1; i < scan.length; i++) {
  // Find distances from a point in the second scan
  for (let pi2 = 0; pi2 < scan[1].length; pi2++) {
    let m2 = distancesFrom(1, pi2)

    // How many of those distances are the same?
    //
    // If we find a point with 11 intersections, then those 11 plus the point
    // itself are the 12 common beacons shared between the two scanners.
    // Furthermore, these two coordinates refer to the same beacon.
    // let ix = intersection(m, beacons)
    let ix = intersection(m1, m2)
    console.log(ix.length)
    if (ix.length !== 11) continue

    console.log(scan[0][0], scan[1][pi2])
    // console.log(ix)
  }
  // }

  console.log('--')

  // Find distances from a point in the third scan
  for (let pi2 = 0; pi2 < scan[2].length; pi2++) {
    let m2 = distancesFrom(2, pi2)

    // How many of those distances are the same?
    //
    // If we find a point with 11 intersections, then those 11 plus the point
    // itself are the 12 common beacons shared between the two scanners.
    // Furthermore, these two coordinates refer to the same beacon.
    // let ix = intersection(m, beacons)
    let ix = intersection(m1, m2)
    console.log(ix.length)
    if (ix.length !== 11) continue

    console.log(scan[0][0], scan[2][pi2])
    // console.log(ix)
  }

  // for (let pi2 = 0; pi2 < scan[1].length; pi2++) {
  // let pi2 = 0
  // let r2 = distances(1, pi2)
  // let ix = intersection(r1, r2)
  // console.log(ix.length)
  // }
  // }
}

const scan = parse(input)
console.log(p1(scan))
