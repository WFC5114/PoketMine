using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float moveSpeed = 5f; // Player movement speed

    private Rigidbody2D rb; // Reference to the Rigidbody2D component
    private Vector2 movement; // Vector to store movement input

    void Start()
    {
        rb = GetComponent<Rigidbody2D>(); // Get and store the Rigidbody2D component
    }

    void Update()
    {
        // Input detection, storing horizontal and vertical input values
        float moveX = Input.GetAxisRaw("Horizontal");
        float moveY = Input.GetAxisRaw("Vertical");

        // Combine input into a movement vector and normalize to ensure consistent movement speed in all directions
        movement = new Vector2(moveX, moveY).normalized;
    }

    void FixedUpdate()
    {
        // Apply movement to the Rigidbody2D based on the movement vector
        rb.velocity = movement * moveSpeed;
    }
}
