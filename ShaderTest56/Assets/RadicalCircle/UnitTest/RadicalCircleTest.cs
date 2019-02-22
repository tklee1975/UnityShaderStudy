using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using SimpleTDD;

public class RadicalCircleTest : BaseTest {
	public RadicalCircle circle1;
	public float percent1 = 0;

	public RadicalCircle circle2;
	public float percent2 = 0;

	[Test]
	public void ChangeCircle1()
	{
		percent1 = (percent1 + 10) % 100;
		
		circle1.Percent = percent1;
	}

	[Test]
	public void ChangeCircle2()
	{
		percent2 = (percent2 + 10) % 100;
		
		circle2.Percent = percent2;
	}
}
