using UnityEngine;

public class RateCounter : MonoBehaviour
{
    void Update () {
        transform.Rotate(0f, 22.5f * Time.deltaTime, 0f);
    }

}