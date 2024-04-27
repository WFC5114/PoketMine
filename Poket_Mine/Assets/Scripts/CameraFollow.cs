using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform target; // The target the camera should follow (usually the player)
    public float boundX = 0.15f;
    public float boundY = 0.05f;
    public Vector3 offset; // The offset from the target position

    private void LateUpdate()
    {
        Vector3 delta = Vector3.zero;
        // check if we are inside x axis
        float deltaX = target.position.x - transform.position.x;
        if (deltaX > boundX || deltaX < -boundX)
        {
            if (transform.position.x < target.position.x)
            {
                delta.x = deltaX - boundX;
            }
            else
            {
                delta.x = deltaX + boundX;
            }
        }
        // check id we are inside y axis
        float deltaY = target.position.y - transform.position.y;
        if (deltaY > boundY || deltaY < -boundY)
        {
            if (transform.position.y < target.position.y)
            {
                delta.y = deltaY - boundY;
            }
            else
            {
                delta.y = deltaY + boundY;
            }
        }


        transform.position += new Vector3(delta.x, delta.y, 0);
    }
}

