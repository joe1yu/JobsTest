using UnityEngine;

public class FractalTrad : MonoBehaviour
{
    [SerializeField, Range(1, 8)]
    int depth = 6;
    FractalTrad CreateChild (Vector3 direction, Quaternion rotation) {
        FractalTrad child = Instantiate(this);
        child.depth = depth - 1;
        child.transform.localPosition = 0.75f * direction;
        child.transform.localRotation = rotation;
        child.transform.localScale = 0.5f * Vector3.one;
        return child;
    }
	
    void Start () {
        name = "Fractal " + depth;
        if (depth <= 1) {
            return;
        }

        FractalTrad childA = CreateChild(Vector3.up, Quaternion.identity);
        FractalTrad childB = CreateChild(Vector3.right, Quaternion.Euler(0f, 0f, -90f));
        FractalTrad childC = CreateChild(Vector3.left, Quaternion.Euler(0f, 0f, 90f));
        FractalTrad childD = CreateChild(Vector3.forward, Quaternion.Euler(90f, 0f, 0f));
        FractalTrad childE = CreateChild(Vector3.back, Quaternion.Euler(-90f, 0f, 0f));

        childA.transform.SetParent(transform, false);
        childB.transform.SetParent(transform, false);
        childC.transform.SetParent(transform, false);
        childD.transform.SetParent(transform, false);
        childE.transform.SetParent(transform, false);
    }

}